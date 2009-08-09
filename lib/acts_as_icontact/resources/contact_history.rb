module ActsAsIcontact
  # The read-only list of actions attached to every Contact.  Because of this intrinsic association, the usual #find methods don't
  # work; contact history _must_ be obtained using the individual contact's #history method.  
  # Property updates and saving are also prohibited (returning a ReadOnlyError exception.)
  class ContactHistory < Resource
    attr_reader :parent
    alias_method :contact, :parent
    
    # Should only be called by ResourceCollection.  Raises an exception if a parent object is not passed.
    def initialize(properties={})
      @parent = properties.delete(:parent) or raise ActsAsIcontact::ValidationError, "Contact History requires a Contact" 
      super
    end
    
    # Properties of this class are read-only.
    def method_missing(method, *params)
      raise ActsAsIcontact::ReadOnlyError, "Contact History is read-only!" if method.to_s =~ /(.*)=$/ 
      super
    end
    
    
    # Returns the ContactHistory collection for the passed contact.  Takes the usual iContact search parameters.
    def self.scoped_find(parent, options = {})
      query_options = default_options.merge(options)
      validate_options(query_options)
      uri_extension = uri_component + build_query(query_options)
      response = parent.connection[uri_extension].get
      parsed = JSON.parse(response)
      ResourceCollection.new(self, parsed, :parent => parent)
    end
  

    class <<self
      # Replace all search methods with an exception
      def cannot_query(*arguments)
        raise ActsAsIcontact::QueryError, "Contact History must be obtained using the contact.history method."
      end
      alias_method :all, :cannot_query
      alias_method :first, :cannot_query
      alias_method :find, :cannot_query
    end
    
    # Replace save methods with an exception
    def cannot_save(*arguments)
      raise ActsAsIcontact::ReadOnlyError, "Contact History is read-only!"
    end
    alias_method :save, :cannot_save
    alias_method :save!, :cannot_save
    
  protected
    # An oddball resource class; iContact's URL for it is 'actions', not 'contact_histories'.
    def self.resource_name
      'action'
    end
    
  end
end