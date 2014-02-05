require 'spec_helper'
# 
# This test excercizes pretty much most of the control methods
# on an actual WiFly.  Supplying the WIFLY_IP as an environment
# variable activates this test. 
# That means you should have the WiFly connected to a network 
# accessible by the computer running this test. 
#
if WIFLY_IP
  describe Wifly do
    it 'should really work' do
      2.times do 
        control=Wifly::Control.new(WIFLY_IP, 2000)
        5.times do |n|
          control.set_high(7)
          control.read_pin(7).should eq(1)
          control.set_low(7)
          control.read_pin(7).should eq(0)
        end
        control.close
      end
    end
  end
end
