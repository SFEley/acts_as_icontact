module ActsAsIcontact
  # A read-only resource placed beneath the URL of another resource and containing secondary information.  
  # Because of this intrinsic association, the usual #find methods don't
  # work; subresources _must_ be obtained using an association method from the parent resource.  
  # Property updates and saving are also prohibited (returning a ReadOnlyError exception.)
  class Subresource < Resource
    attr_reader :parent
    
    # Should only be called by ResourceCollection.  Raises an exception if a parent object is not passed.
    def initialize(properties={})
      @parent = properties.delete(:parent) or raise ActsAsIcontact::ValidationError, "#{self.class.readable_name} requires a #{self.class.readable_parent}" 
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
        raise ActsAsIcontact::QueryError, "#{readable_name} must be obtained using the #{readable_parent}\##{parent_method} method."
      end
      alias_method :all, :cannot_query
      alias_method :first, :cannot_query
      alias_method :find, :cannot_query
    end
    
  protected
    # An oddball resource class; iContact's URL for it is 'actions', not 'contact_histories'.
    def self.resource_name
      'action'
    end
    
    def self.readable_name
      name.demodulize.titleize
    end
    
    def self.readable_parent
      readable_name.split[0]
    end
    
    def self.parent_method
      readable_name.split[1].downcase
    end
  end
end