module ActsAsIcontact
  # The nested Client Folder resource from iContact.  Currently only supports retrieval -- and is 
  # highly targeted toward the _first_ client folder, since that seems to be the dominant use case.
  class ClientFolder < Resource
    # Derives from the Account resource.
    def self.base
      ActsAsIcontact.account
    end
    
    def self.resource_name
      'clientfolder'
    end
    
    def self.collection_name
      'clientfolders'
    end
    
    def self.uri_component
      'c'
    end
    
    def self.base
      ActsAsIcontact.account
    end
  end
  
  # The clientFolderId retrieved from iContact.  Can also be set manually for performance 
  # optimization, but remembers it so that it won't be pulled more than once anyway.
  def self.clientfolder_id
    @clientfolder_id ||= ClientFolder.first.clientFolderId.to_i
  end
  
  # Manually sets the clientFolderId used in subsequent calls.  Setting this in your 
  # initializer will save at least one unnecessary request to the iContact server.
  def self.clientfolder_id=(val)
    @clientfolder_id = val
  end
  
  # RestClient subresource scoped to the specific account ID.  Most other iContact calls will derive
  # from this one.
  def self.clientfolder
    @clientfolder ||= account["c/#{clientfolder_id}"]
  end
  
  # Clears the account resource from memory.  Called by reset_connection! since the only likely reason
  # to do this is connecting as a different user.
  def self.reset_clientfolder!
    @clientfolder = nil
  end
end