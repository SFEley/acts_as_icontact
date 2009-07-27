module ActsAsIcontact
  class CustomField < Resource
    
    # Has a default fieldType of "text" and displayToUser of "false" if not overridden as options.
    def initialize(properties={})
      # Capture privateName as the ID field if it was passed in
      @customFieldId = properties["privateName"] || properties[:privateName]
      super({:fieldType => "text", :displayToUser => false}.merge(properties))
    end
    
    # Uses privateName as its ID in resource URLs.  The custom field resource is just weird that way.
    def id
      @customFieldId
    end
    
    # privateName must not contain certain punctuation; fieldType must be "text" or "checkbox".
    def validate_on_save(fields)
      raise ActsAsIcontact::ValidationError, "privateName cannot contain spaces, quotes, slashes or brackets" if fields["privateName"] =~ /[\s\"\'\/\\\[\]]/
      raise ActsAsIcontact::ValidationError, "fieldType must be 'text' or 'checkbox'" unless fields["fieldType"] =~ /^(text|checkbox)$/
    end
      
    
    # Searches on privateName.  For this class it's the proper way to find by the primary key anyway.
    def self.find_by_string(value)
      find_by_id(value)
    end
    
    # Requires privateName, displayToUser, fieldType
    def self.required_on_create
      super + %w(privateName displayToUser fieldType)
    end
    
    # Treats displayToUser as a boolean field (accepts true and false)
    def self.boolean_fields
      super << "displayToUser"
    end
    
    # Uses privateName as its primary key field
    def self.primary_key
      "privateName"
    end
    
    # Returns an array listing all custom fields.  This is very convenient for certain tasks (e.g. the mapping in our Rails integration).
    def self.list
      list = []
      fields = self.all
      fields.each {|f| list << f.privateName}
      list
    end
  end
end