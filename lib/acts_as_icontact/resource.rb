require 'activesupport'
module ActsAsIcontact
  # Base class for shared functionality between iContact resources.  Supports getting, finding, saving,
  # all that fun stuff. 
  class Resource
    
    # Creates a new resource object from a values hash.  (Which is passed to us via the magic of JSON.)
    def initialize(properties=nil)
      @properties = properties
    end
    
    # Enables keys from the iContact resource to act as attribute methods.
    def method_missing(method, *params)
      property = method.to_s
      if @properties.has_key?(property)
        @properties[property]
      else
        raise
      end
    end
    
    protected
    # The name of the singular resource type pulled from iContact.  Defaults to the lowercase
    # version of the class name.
    def self.resource_name
      name.demodulize.camelcase(:lower)
    end

    # The name of the resource collection pulled from iContact.  Defaults to the lowercase
    # pluralized version of the class name.
    def self.collection_name
      resource_name.pluralize
    end
    
  end
  
  # The accountId retrieved from iContact.  Can also be set manually for performance optimization,
  # but remembers it so that it won't be pulled more than once anyway.
  def self.account_id
    @account_id ||= Account.first.accountId.to_i
  end
  
  # Manually sets the accountId used in subsequent calls.  Setting this in your initializer will save
  # at least one unnecessary request to the iContact server.
  def self.account_id=(val)
    @account_id = val
  end
  
  # RestClient subresource scoped to the specific account ID.  Most other iContact calls will derive
  # from this one.
  def self.account
    @account ||= connection["a/#{account_id}"]
  end
  
  # Clears the account resource from memory.  Called by reset_connection! since the only likely reason
  # to do this is connecting as a different user.
  def self.reset_account!
    @account = nil
  end
end