# Wifly

This Ruby gem can be used to talk to a [WiFly RN-XV](http://www.rovingnetworks.com/products/RN171XV) device at a specified address.  The gem has no dependencies other than the socket libraries that ship with any Ruby installation.  

## Installation

Add this line to your application's Gemfile:

    gem 'wifly'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wifly

## Usage
Create a client by passing in the host and port

    control = Wifly::Control.new('192.168.1.45', 2000)

Read the high pins:

    control.high_pins   # [3,7,9,15]

Set a pin to high or low:

    control.set_high(5)
    control.high_pins   # [3,5,7,9,15]

    control.set_low(7)
    control.high_pins   # [3,5,9,15]

Read a single pin:

    control.read_pin(7) # 0
    control.read_pin(5) # 1

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
