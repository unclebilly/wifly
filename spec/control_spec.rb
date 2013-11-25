require 'spec_helper'
describe Wifly::Control do
  it 'should set high and low' do
    connection = double('connection')
    connection.should_receive(:send_command).with("set sys output 0x20 0x20", Wifly::AOK.length)
    connection.should_receive(:send_command).with("set sys output 0x00 0x20", Wifly::AOK.length)
    control = Wifly::Control.new('localhost', 2000, '1.2', connection)
    control.set_high(5)
    control.set_low(5)
  end

  it 'should get high pins' do
    connection = double('connection')
    connection.should_receive(:send_command).exactly(2).times.and_return("show io\r\r\n8d08\r\n")
    control = Wifly::Control.new('localhost', 2000, '1.2', connection)

    control.read_pin(8).should eq(1)
    control.read_pin(7).should eq(0)
  end
end