module ActsAsIcontact
  
  # Subscriptions are effectively a "has_many :through" mapping between Contacts and Lists.  They are implemented
  # that way, with a .lists property on Contact and a .subscribers property on List that both work through the 
  # Subscription class.
  class Subscription < Resource
    
    STATUSES = %w(normal pending unsubscribed)
    
    # Defaults status to "normal"
    def initialize(properties = {})
      super({:status => "normal"}.merge(properties))
    end
    
    # Searches on the compound primary key ("listid_contactid").  
    def self.find_by_string(value)
      find_by_id(value)
    end
          
    # Requires listId, contactId, and status when creating a record
    def self.required_on_create
      super + %w(listId contactId status)
    end
    
    # Never send listId or contactId on update
    def self.never_on_update
      super + %w(listId contactId)
    end
    
    # status must be one of: normal, pending, unsubscribed
    def validate_on_save(fields)
      raise ActsAsIcontact::ValidationError, "Status must be one of: #{STATUSES.join(', ')}" unless STATUSES.include?(fields["status"])
    end
    
    # The list that this subscription is associated with.
    def list
      ActsAsIcontact::List.find(listId) if properties["listId"]
    end
    
    # The contact that this subscription is associated with.
    def contact
      ActsAsIcontact::Contact.find(contactId) if properties["contactId"]
    end
    
    # The confirmation message for this subscription, if any.
    def confirmationMessage
      ActsAsIcontact::Message.find(confirmationMessageId) if properties["confirmationMessageId"]
    end
      
  end
  
end