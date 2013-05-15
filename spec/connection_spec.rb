require 'wifly'
class Wifly::TestServer
  attr_accessor :input

  def initialize(port)
    @socket = TCPServer.new(port)
  end

  def simple_connect
    @client = @socket.accept
    self.input = @client.read(Wifly::COMMAND_MODE.length) 
    @client.write(Wifly::HELLO)
    @client.close
  end

  def receive_command(command, version)
    @client = @socket.accept

    @client.write(Wifly::HELLO)
    @client.read((command + "\r").length)
    @client.write(command + "\r\r\n<" + version + '> ')
    @client.close
  end
end

describe Wifly::Connection do
  before(:all) do
    @server = Wifly::TestServer.new(2000)
  end
  it 'should set stuff on initialize' do
    connection = Wifly::Connection.new('localhost', 2000, '2.3.13')
    connection.address.should eq('localhost')
    connection.port.should eq(2000)
    connection.version.should eq('2.3.13')
  end

  it 'should enter command mode' do
    t = Thread.new do
      @server.simple_connect
    end
    connection = Wifly::Connection.new('localhost', 2000, '2.3.13')
    connection.socket
    t.join
    @server.input.should eq(Wifly::COMMAND_MODE)
    connection.close
  end

  it 'should send commands correctly' do
    t = Thread.new do
      @server.receive_command("lites", '123')
    end
    connection = Wifly::Connection.new('localhost', 2000, '123')

    result = connection.send_command("lites")
    t.join
    result.should eq("lites\r\r\n")
    connection.close
  end
end