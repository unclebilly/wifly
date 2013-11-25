require 'spec_helper'

class WiflyControlShim
  include Wifly::Calculations
end

describe Wifly::Calculations do
  it 'should convert pin to hex' do
    control = WiflyControlShim.new
    control.pin_to_hex(5).should eq("0x20")
    control.pin_to_hex(0).should eq("0x0")
  end 

  it 'should get high pins' do
    control = WiflyControlShim.new
    result = control.parse_io('8d08')
    result.should eq([3, 8, 10, 11, 15])
    result = control.parse_io('8103')
    result.should eq([0, 1, 8, 15])
  end
end