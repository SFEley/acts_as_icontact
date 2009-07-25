module ActsAsIcontact
  # The top-level Accounts resource from iContact.  Currently only supports retrieval -- and is 
  # highly targeted toward the _first_ account, since that seems to be the dominant use case.
  class Account < Resource
    # This is the one major resource that comes directly from the main path.
    def self.base
      ActsAsIcontact.connection
    end
    
    def self.uri_component
      'a'
    end
    
    # Accounts can't pass back a userName or password on updating
    def self.never_on_update     
      ['userName','password']
    end
  end
  
  # The accountId retrieved from iContact.  Can also be set manually for performance optimization,
  # but remembers it so that it won't be pulled more than once anyway.
  def self.account_id
    @account_id ||= Account.first.id.to_i
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