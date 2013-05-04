require 'wifly'
describe Wifly::Control do
  it 'should convert pin to hex' do
    control = Wifly::Control.new('localhost', 2000, '1.2', {})
    control.pin_to_hex(5).should eq("0x20")
    control.pin_to_hex(0).should eq("0x0")
  end 

  it 'should get high pins' do
    connection = double('connection')
    connection.should_receive(:send_command).exactly(3).times.and_return("show io\r\r\n8d08\r\n")
    control = Wifly::Control.new('localhost', 2000, '1.2', connection)
    result = control.high_pins
    result.should eq([3, 8, 10, 11, 15])
    control.read_pin(8).should eq(1)
    control.read_pin(7).should eq(0)
  end

  it 'should set high and low' do
    connection = double('connection')
    connection.should_receive(:send_command).with("set sys output 0x20 0x20", Wifly::Control::AOK.length)
    connection.should_receive(:send_command).with("set sys output 0x00 0x20", Wifly::Control::AOK.length)
    control = Wifly::Control.new('localhost', 2000, '1.2', connection)
    control.set_high(5)
    control.set_low(5)
  end
end