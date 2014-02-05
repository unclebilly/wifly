module Wifly
  class Connection
    attr_accessor :address, :port
  
    ##
    # address => the hostname or IP address of the wifly device
    # port =>    the port for communicating with the wifly
    def initialize(address, port)
      self.address = address
      self.port    = port
    end

    ##
    # str =>  the command to send to the wifly, without any carriage return
    # [return_len] => the expected length of the return string; defaults to 0
    #
    # The wifly will echo back the command (with carriage return)
    # along with another CRLF and the command prompt string.
    # Something like "lites\r\r\n<2.32> "
    #
    def send_command(str)
      str += "\r"
      write(socket, str) # the write is blocking
      sleep(0.2)
      read(socket).gsub(prompt,'')
    end


    def close
      socket.close
    end

    def socket
      @socket ||= initialize_socket
    end
    
    private

    def read(sock)
      result = ''
      begin
        result = sock.read_nonblock(1024)
      # connection lost somehow
      rescue Errno::ECONNRESET, Errno::EPIPE, IOError
        initialize_socket
        read(socket)
      # No more data on socket
      rescue Errno::EAGAIN
        retry
      rescue EOFError => e
        # ain't nothin left on socket.  
      end
      result.strip
    end

    def write(sock, str)
      begin
        sock.write(str)
      rescue Errno::EPIPE, IOError
        initialize_socket
        write(socket, str)
      end
    end

    def prompt
      # 2.32
      # 3.2.23
      /<[0-9]{1,}\.[0-9]{1,}(\.[0-9]{1,})?>/
    end

    def initialize_socket
      sock = Socket.tcp(address, port)
      write(sock, COMMAND_MODE) # enter command mode 
      read(sock) # read off the response
      sock
    end 
  end
end