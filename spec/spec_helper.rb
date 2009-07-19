require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'acts_as_icontact'

require 'spec_fakeweb'

Spec::Runner.configure do |config|
  # config.after(:each) do
  #   # Make sure we don't run afoul of iContact's rate limiting
  #   sleep 1
  # end
  config.mock_with :mocha
  
  # Set up some reasonable testing variables
  ActsAsIcontact::Config.beta = true
end
