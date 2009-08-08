module ActsAsIcontact
  class Message < Resource
    # Has a default messageType of "normal" if another isn't passed as an option.
    def initialize(properties={})
      super({:messageType => "normal"}.merge(properties))
    end
    
    # Requires messageType and subject
    def self.required_on_create
      super << "messageType" << "subject"
    end
    
    # messageType must be one of four values: normal, autoresponder, welcome, or confirmation
    def validate_on_save(fields)
      messageType = %w(normal autoresponder welcome confirmation)
      raise ActsAsIcontact::ValidationError, "messageType must be one of: " + messageType.join(', ') unless messageType.include?(fields["messageType"])
    end
    
    # Returns the Campaign resource associated with this message, if campaignId is set.  Otherwise returns nil.  Returns an exception if the campaignId is set but the campaign cannot be found.
    def campaign
      if (c = campaignId.to_i) > 0
        Campaign.find(c)
      else
        nil
      end
    end
  end
end