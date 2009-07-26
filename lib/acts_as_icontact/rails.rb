# Load all of our Rails files
Dir[File.join(File.dirname(__FILE__), 'rails', '*.rb')].sort.each do |path|
  filename = File.basename(path, '.rb')
  require "acts_as_icontact/rails/#{filename}"
end

# module ActsAsIcontact
#   module Rails
#     module ClassMethods
#       extend Mappings
#       extend Macro
#     end
#   end
# end

if defined?(::ActiveRecord)
  module ::ActiveRecord
    class Base
      extend ActsAsIcontact::Rails::ClassMethods::Mappings
      extend ActsAsIcontact::Rails::ClassMethods::Macro
    end
  end
end