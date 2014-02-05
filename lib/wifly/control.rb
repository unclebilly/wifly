module Wifly
  class Control
    include Calculations
    
    attr_accessor :connection

    ##
    # address    - the hostname or IP address 
    # port       - defaults to 2000
    # connection - the object to use for talking to the wifly. Responds to "send_command."
    #              Defaults to Wifly::Connection. 
    #
    def initialize(address, port, connection=nil)
      self.connection   = connection || Connection.new(address, port)
    end

    ##
    # Toggle the blinking lights on the device
    #
    def lites
      connection.send_command("lites")
    end

    ##
    # set a pin high
    #
    def set_high(pin)
      hex = pin_to_hex(pin)
      connection.send_command "set sys output #{hex} #{hex}"
    end

    ##
    # set a pin low
    #
    def set_low(pin)
      hex = pin_to_hex(pin)
      connection.send_command "set sys output 0x00 #{hex}"
    end

    ##
    # given a pin number, return 1 if high or 0 if low
    #
    def read_pin(pin)
      high_pins.include?(pin) ? 1 : 0
    end

    ##
    # Return an array of all the pins which are currently high 
    #
    def high_pins
      parse_io(read_io)
    end

    ##
    # Close the connection.    
    #
    def close
      connection.close
    end

    private

    ##
    # Gets the status of all IO pins on wifly. Returns a hex string.
    #
    def read_io
      cmd = "show io\r"

      # result is something like 'show io\r\r\n8d08'
      str = connection.send_command "show io"

      # Return only the middle part, which is the io state
      str.gsub(cmd,'').strip
    end
  end
end