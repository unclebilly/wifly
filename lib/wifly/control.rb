module Wifly
  class Control
    attr_accessor :connection

    ##
    # address    - the hostname or IP address 
    # port       - defaults to 2000
    # version    - the firmware version (a string)
    # connection - the object to use for talking to the wifly. Responds to "send_command."
    #              Defaults to Wifly::Connection. 
    #
    def initialize(address, port, version, connection=nil)
      self.connection   = connection || Connection.new(address, port, version)
    end

    ##
    # Toggle the blinking lights on the device
    #
    def lites
      connection.send_command("lites")
    end

    ##
    # Return an array containing the numbers of the pins that are in HIGH state
    #
    def high_pins
      io=read_io
                      #"8d08"   36104   "1000110100001000"   make it 16 bits
      binary_string = io       .hex     .to_s(2)             .rjust(io.size*4, '0')
      binary_string.reverse.split("").each_with_index.map do |value, pin|
        pin if value == "1"
      end.compact
    end

    ##
    # set a pin high
    #
    def set_high(pin)
      hex = pin_to_hex(pin)
      connection.send_command "set sys output #{hex} #{hex}", AOK.length
    end

    ##
    # set a pin low
    #
    def set_low(pin)
      hex = pin_to_hex(pin)
      connection.send_command "set sys output 0x00 #{hex}", AOK.length
    end

    ##
    # given a pin number, return 1 if high or 0 if low
    #
    def read_pin(pin)
      high_pins.include?(pin) ? 1 : 0
    end

    ## 
    # Given a pin number, return the hex code that corresponds to it
    #
    def pin_to_hex(pin)
      return "0x0" if pin == 0
      binstr = "0b1" + ("0" * pin) # make a binary string with a 1 in `pin` position
      base10 = binstr.to_i(2)      # convert to base 10
      "0x" + base10.to_s(16)       # return hexadecimal string
    end

    private

    ##
    # Gets the status of all IO pins on wifly. Returns a hex string.
    #
    def read_io
      cmd = "show io\r"

      # wifly spits back something like 'show io\r\r\n8d08\r\n<2.32> '
      # crucially, the middle part "8d08\r\n" is always the same length
      str = connection.send_command("show io", "8d08\r\n".length)

      # Return only the middle part, which is the io state
      str.gsub(cmd,'').strip
    end
  end
end