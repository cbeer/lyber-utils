$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'coveralls'
Coveralls.wear!

# require 'rubygems'
# require 'rspec'

RSpec.configure do |config|

end

Rails = Object.new unless defined? Rails
