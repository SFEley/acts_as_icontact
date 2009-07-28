module ActsAsIcontact
  class List < Resource
    # Derives from clientFolder.
    def self.base
      ActsAsIcontact.client
    end
    
    # Searches on list name.
    def self.find_by_string(value)
      first(:name => value)
    end
    
    # Requires name, emailOwnerOnChange, welcomeOnManualAdd, welcomeOnSignupAdd, and welcomeMessageId.
    def self.required_on_create
      super << "name" << "emailOwnerOnChange" << "welcomeOnManualAdd" << "welcomeOnSignupAdd" << "welcomeMessageId"
    end
    
    def self.boolean_fields
      super << "emailOwnerOnChange" << "welcomeOnManualAdd" << "welcomeOnSignupAdd"
    end
    
    # The welcome message pointed to by the welcomeMessageId.
    def welcomeMessage
      return nil unless welcomeMessageId
      ActsAsIcontact::Message.find(welcomeMessageId)
    end
    
    # Returns the contacts subscribed to this list (via the Subscription class).
    def subscribers
      @subscribers ||= ActsAsIcontact::Subscription.contacts(:listId => id)
    end
    
  end
end