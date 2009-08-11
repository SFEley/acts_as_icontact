require 'rubygems'
require 'rest_client'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'acts_as_icontact/exceptions'
require 'acts_as_icontact/config'
require 'acts_as_icontact/connection'
require 'acts_as_icontact/resource'
require 'acts_as_icontact/resource_collection'
require 'acts_as_icontact/subresource'
require 'acts_as_icontact/readonly'

# Load all of our resource files
Dir[File.join(File.dirname(__FILE__), 'acts_as_icontact', 'resources', '*.rb')].sort.each do |path|
  filename = File.basename(path, '.rb')
  require "acts_as_icontact/resources/#{filename}"
end

module ActsAsIcontact
end
