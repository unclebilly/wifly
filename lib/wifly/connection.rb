module Wifly
  class Connection
    HELLO = '*HELLO*CMD\r\n'

    attr_accessor :address, :port, :version
  
    ##
    # address => the hostname or IP address of the wifly device
    # port =>    the port for communicating with the wifly
    # version => the firmware version of the device
    def initialize(address, port, version)
      self.address = address
      self.port    = port
      self.version = version
    end

    ##
    # str =>  the command to send to the wifly, without any carriage return
    # [return_len] => the expected length of the return string; defaults to 0
    #
    # The wifly will echo back the command (with carriage return)
    # along with another CRLF and the command prompt string.
    # Something like "lites\r\r\n<2.32> "
    # Since the string has a predictable length, we can do a blocking read.
    #
    def send_command(str, return_len=0)
      str += '\r'
      socket.write(str)
      expected_return_length = str.length + '\r\n#{prompt}'.length + return_len
      socket.read(expected_return_length).gsub(prompt,'') 
    end

    def close
      socket.close
    end

    def socket
      @socket ||= initialize_socket
    end
    
    private
    def prompt
      "<#{version}> "
    end

    def initialize_socket
      sock = Socket.tcp(address, port)
      sock.write('$$$\r') # enter command mode 
      sock.read(HELLO.length)       # read off the response, "*HELLO*CMD\r\n"
      sock
    end 
  end
end