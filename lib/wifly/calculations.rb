module Wifly
  module Calculations
    ##
    # Parse the hexadecimal string returned from the show_io command
    # into an array of pins that are high 
    #
    def parse_io(hex_str)
      # use sprintf to pad with 0's to 16 bits
      binary_string = "%016b"  % hex_str.hex.to_i
      binary_string.reverse.chars.each_with_index.map do |value, pin|
        pin if value == "1"
      end.compact
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
  end
end