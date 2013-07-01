require 'socket'
require 'wifly/connection'
require 'wifly/calculations'
require 'wifly/control'
require 'wifly/version'

module Wifly
  AOK          = "\r\nAOK"
  HELLO        = "*HELLO*CMD\r\n"
  COMMAND_MODE = "$$$\r"
end