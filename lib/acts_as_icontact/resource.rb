require 'active_support'
require 'uri'

module ActsAsIcontact
  # Base class for shared functionality between iContact resources.  Supports getting, finding, saving,
  # all that fun stuff. 
  class Resource
    
    # Creates a new resource object from a values hash.  (Which is passed to us via the magic of JSON.)
    def initialize(properties={})
      @properties = clean_properties(properties)
      @new_record = !@properties.has_key?(self.class.primary_key)
      # Initialize other useful attributes
      @errors = []
    end
    
    # Returns the primary key ID for an existing resource.  Returns nil if the resource is a new record.
    def id
      @properties[self.class.primary_key].to_i unless new_record?
    end
    
    # Returns the specific RestClient connection for an existing resource.  (E.g., the connection
    # to "http://api.icontact.com/icp/a/12345" for account 12345.)  Returns nil if the resource
    # is a new record.
    def connection
      self.class.connection[id] unless new_record?
    end
    
    # Enables keys from the iContact resource to act as attribute methods.
    def method_missing(method, *params)
      property = method.to_s
      if property =~ /(.*)=$/  # It's a value assignment
        @newvalues ||= []
        @newvalues << $1
        @properties[$1] = clean_value(params[0])
       else
        if @properties.has_key?(property)
          if self.class.boolean_fields.include?(property)
            (@properties[property] == 1)
          else
            @properties[property]
          end
        else
          super
        end
      end
    end
    
    # Returns true if the resource object did not originate from iContact.  We determine this 
    # by the rather naive method of checking upon creation whether one of the properties passed
    # was the primary key.
    def new_record?
      @new_record
    end
    
    # Sends changes to iContact.  Returns true if the save was successful (i.e. we receive
    # an updated object back from them); if it was not, returns false and populates the
    # +errors+ array with the warnings iContact sends to us.  If iContact returns an HTTP
    # error, raises an exception with it.
    def save
      if new_record?
        fields = create_fields
        validate_on_create(fields)
        result_type = self.class.collection_name
        response = self.class.connection.post([fields].to_json)
      else
        fields = update_fields
        validate_on_update(fields)
        result_type = self.class.resource_name
        response = connection.post(fields.to_json)
      end
      parsed = JSON.parse(response)
      if parsed[result_type].empty?
        @errors = parsed["warnings"] || []
        false
      else
        @properties = (new_record? ? parsed[result_type].first : parsed[result_type])
        @new_record = false
        @errors = []
        true
      end 
    rescue RestClient::RequestFailed => e
      response = e.response.body
      parsed = JSON.parse(response)
      @errors = parsed["errors"] || [e.message]
      false
    end
    
    # Like +save+, but raises an ActsAsIcontact::SaveError exception if the save
    # failed.  The exception message contains the first error from iContact.
    def save!
      save or raise ActsAsIcontact::SaveError.new(errors)
    end
    
    # The first message from the +errors+ array.
    def error
      errors.first
    end
    
    # The warning messages sent back by iContact on a failed request.
    def errors
      @errors
    end
    
    # Returns a resource or collection of resources.  
    def self.find(type, options={})
      case type
      when :first
        first(options)
      when :all
        all(options)
      when Integer
        find_by_id(type)
      when String
        find_by_string(type)  # Implemented in subclasses
      else
        raise ActsAsIcontact::QueryError, "Don't know how to find '#{type.to_s}'"
      end
    end
    
    # Returns an array of resources starting at the base.
    def self.all(options={})
      query_options = default_options.merge(options)
      validate_options(query_options)
      result = query_collection(query_options)
      ResourceCollection.new(self, result)
    end
    
    # Returns the first account associated with this username.
    def self.first(options={})
      query_options = default_options.merge(options).merge(:limit => 1) # Minor optimization
      validate_options(query_options)
      result = query_collection(query_options)
      self.new(result[collection_name].first)
    end
    
    # Returns the single resource at the URL identified by the passed integer.  Takes no options; this is 
    # not a search, this is a single record retrieval.  Raises an exception if the record can't be found.
    def self.find_by_id(id)
      response = self.connection[id].get
      parsed = JSON.parse(response)
      raise ActsAsIcontact::QueryError, "iContact's response did not contain a #{resource_name}!" unless parsed[resource_name]
      self.new(parsed[resource_name])
    rescue RestClient::ResourceNotFound
      raise ActsAsIcontact::QueryError, "The #{resource_name} with id #{id} could not be found"
    end
    
    # Two resources are identical if they have exactly the same property array.
    def ==(obj)
      properties == obj.properties
    end
    
    # Returns a nice formatted string for command line use.
    def inspect
      properties.to_yaml
    end
    
    # An array of all defined property keys for this resource.
    def property_names
      properties.symbolize_keys.keys
    end
    
    protected
    # The minimum set of fields that must be sent back to iContact on an update.
    # Includes any fields that changed or were added, the primary key, and anything
    # else from the "required_on_update" set from the class definition.  It excludes
    # anything from the "never_on_update" set.
    def update_fields
      fieldlist = self.class.required_on_update + @newvalues.to_a - self.class.never_on_update
      @properties.select{|key, value| fieldlist.include?(key)}
    end

    # The minimum set of fields that must be sent back to iContact on a create.
    # Includes any fields that were added and anything
    # else from the "required_on_create" set from the class definition.  It excludes
    # anything from the "never_on_create" set.
    def create_fields
      self.class.required_on_create.each{|key| @properties[key] ||= ""} # Add required fields
      self.class.never_on_create.each{|key| @properties.delete(key)} # Remove prohibited fields
      @properties
    end
    
    # The base RestClient resource that this particular class nests from.  Defaults to 
    # the clientFolders path since that's the most common case.
    def self.base
      ActsAsIcontact.clientfolder
    end
    
    # The name of the singular resource type pulled from iContact.  Defaults to the lowercase
    # version of the class name.
    def self.resource_name
      name.demodulize.downcase
    end

    # The name of the resource collection pulled from iContact.  Defaults to the lowercase
    # pluralized version of the class name.
    def self.collection_name
      resource_name.pluralize
    end
    
    # The URI component name corresponding to this resource type.  In many cases it's the same as the
    # collection name; exceptions include accounts ('a') and clientFolders ('c').
    def self.uri_component
      collection_name
    end
    
    # The RestClient resource object for this resource class.  Its own find/update methods
    # will call on this, and singular objects will derive from it.
    def self.connection
      base[uri_component]
    end
    
    # Allows some subclasses to implement finding by a key identifier string.  The base resource just throws an exception.
    def self.find_by_string(value)
      raise ActsAsIcontact::QueryError, "You cannot search on #{collection_name} with a string value!"
    end
    
    # The primary key field for this resource.  Used on updates.
    def self.primary_key
      resource_name + "Id"
    end
    
    # Options that are always passed on 'find' requests unless overridden.
    def self.default_options
      {:limit => 500}
    end
      
    # Fields that _must_ be included for this resource upon creation.
    def self.required_on_create
      []
    end
    
    # Fields that _must_ be included for this resource upon updating.
    def self.required_on_update
      [primary_key]
    end
    
    # Fields that _cannot_ be included for this resource upon creation.
    def self.never_on_create
      [primary_key]
    end
    
    # Fields that _cannot_ be included for this resource upon updating.
    def self.never_on_update
      []
    end
    
    # Fields that operate as 0/1 boolean toggles.  Can be assigned to with true and false.
    def self.boolean_fields
      []
    end
    
    # Validation rules that ensure proper parameters are passed to iContact on querying.
    def self.validate_options(options)
      # See: http://developer.icontact.com/forums/api-beta-moderated-support/there-upper-limit-result-sets#comment-136
      raise ActsAsIcontact::QueryError, "Limit must be between 1 and 500" if options[:limit].to_i < 1 or options[:limit].to_i > 500 
    end
    
    # Validation rules that ensure proper data is passed to iContact on resource creation.
    def validate_on_create(fields)
      check_required_fields(fields, self.class.required_on_create)
      validate_on_save(fields)
    end

    # Validation rules that ensure proper data is passed to iContact on resource update.
    def validate_on_update(fields)
      check_required_fields(fields, self.class.required_on_update)
      validate_on_save(fields)
    end
    
    # Validation rules that apply to both creates and updates.  The method on the abstract Resource class is just a placeholder;
    # this is intended to be used by resource subclasses.
    def validate_on_save(fields)
    end
    
    # Finesses the properties hash passed in to make iContact and Ruby idioms compatible.  
    # Turns symbol keys into strings and runs the clean_value method on values.
    # Subclasses may add additional conversions.
    def clean_properties(properties={})
      newhash = {}
      properties.each_pair do |key, value|
        newhash[key.to_s] = clean_value(value)
      end
      newhash
    end
    
    # Finesses values passed in to properties to make iContact and Ruby idioms compatible.
    # Turns symbols into strings, numbers into integers or floats, true/false into 1 and 0,
    # and empty strings into nil. Subclasses may add additional conversions.
    def clean_value(value)
      case value
      when Symbol then value.to_s
      when TrueClass then 1
      when FalseClass then 0
      when /^\d+$/ then value.to_i  # Integer
      when /^\d+(\.\d+)?([eE]\d+)?$/ then value.to_f  # Float
      when blank? then nil
      else value
      end 
    end
    
    # The properties array, for comparison against other resources or debugging.
    def properties
      @properties
    end
    
    private
    def self.build_query(options={})
      return "" if options.empty?
      terms = options.collect{|k,v| "#{k}=#{URI.escape(v.to_s)}"}
      build = "?" + terms.join('&')
    end
    
    def self.query_collection(options={})
      uri_extension = uri_component + build_query(options)
      response = base[uri_extension].get
      parsed = JSON.parse(response)
      parsed
    end
    
    def check_required_fields(fields, required)
      # Check that all required fields are filled in
      missing = required.select{|f| fields[f].blank?}
      unless missing.empty?
        missing_fields = missing.join(', ')
        raise ActsAsIcontact::ValidationError, "Missing required fields: #{missing_fields}"
      end
    end
  end
end