module ActsAsIcontact
  class Contact < Resource
    
    # Email is required
    def self.required_on_create
      super << 'email'
    end
    
    # Derived from clientFolder
    def self.base
      ActsAsIcontact.client
    end
    
    # Defaults to status=total to return contacts on or off lists
    def self.default_options
      super.merge(:status=>:total)
    end
   
    # Returns the lists to which this contact is subscribed (via the Subscription class).
    def lists
      @lists ||= ActsAsIcontact::Subscription.lists(:contactId => id)
    end
    
  end
end