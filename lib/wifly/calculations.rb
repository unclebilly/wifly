module Wifly
  module Calculations
    ##
    # Parse the hexadecimal string returned from the show_io command
    # into an array of pins that are high 
    #
    def parse_io(hex_str)
                      #"8d08"   36104   "1000110100001000"   make it 16 bits
      binary_string = hex_str   .hex     .to_s(2)             .rjust(hex_str.size*4, '0')
      binary_string.reverse.split("").each_with_index.map do |value, pin|
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