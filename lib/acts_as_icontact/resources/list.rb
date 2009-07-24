module ActsAsIcontact
  class List < Resource
    # Derives from clientFolder.
    def self.base
      ActsAsIcontact.client
    end
    
    # Requires name, emailOwnerOnChange, welcomeOnManualAdd, welcomeOnSignupAdd, and welcomeMessageId.
    def self.required_on_create
      super << "name" << "emailOwnerOnChange" << "welcomeOnManualAdd" << "welcomeOnSignupAdd" << "welcomeMessageId"
    end
    
    def self.boolean_fields
      super << "emailOwnerOnChange" << "welcomeOnManualAdd" << "welcomeOnSignupAdd"
    end
  end
end