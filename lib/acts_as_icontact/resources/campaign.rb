module ActsAsIcontact
  class Campaign < Resource
    
    # Defaults forwardToFriend to 0; subscriptionManagement, clickTrackMode to true; and useAccountAddress, archiveByDefault to false
    def initialize(properties={})
      super({:forwardToFriend => 0,
             :clickTrackMode => true,
             :subscriptionManagement => true,
             :useAccountAddress => false,
             :archiveByDefault => false}.merge(properties))
    end
    
    # Requires name, fromName, fromEmail, forwardToFriend, subscriptionManagement, clickTrackMode, useAccountAddress, and archiveByDefault
    def self.required_on_create
      super + %w(name fromName fromEmail forwardToFriend subscriptionManagement clickTrackMode useAccountAddress archiveByDefault)
    end
      
    # The following can be set with true or false: subscriptionManagement, clickTrackMode, useAccountAddress, archiveByDefault
    def self.boolean_fields
      super + %w(subscriptionManagement clickTrackMode useAccountAddress archiveByDefault)
    end
    
    # Returns a collection of all Message resources matching this campaignId.  Additional search options can be passed to further restrict the result set.
    def messages(options={})
      search = {:campaignId => id}.merge(options)
      Message.all(search)
    end
    
  end
end