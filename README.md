# Wifly

This Ruby gem can be used to talk to a [WiFly RN-XV](http://www.rovingnetworks.com/products/RN171XV) device at a specified address.  The gem has no dependencies other than the socket libraries that ship with any Ruby installation.  The gem takes advantage of the predictable size of the response strings from the WiFly by using blocking IO operations.  Using blocking operations significantly reduces the complexity of the code.  There are a couple of caveats with using blocking reads, though: 
* Unexpected output from the WiFly could cause the client to deadlock on a socket read, or could cause corrupt data in subsequent reads.  I've tried to find the variants of output that I'm concerned with in my project; however, you might find some edge cases I haven't covered.  In that case, pull requests are welcome. 
* The version of the firmware must be passed into the client so that the size of the response strings can be predicted.  

## Installation

Add this line to your application's Gemfile:

    gem 'wifly'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wifly

## Usage
Create a client by passing in the host, port, and firmware version:

    control = Wifly::Control.new('192.168.1.45', 2000, '2.31.7')

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
