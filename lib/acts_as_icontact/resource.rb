require 'activesupport'
require 'uri'

module ActsAsIcontact
  # Base class for shared functionality between iContact resources.  Supports getting, finding, saving,
  # all that fun stuff. 
  class Resource
    
    # Creates a new resource object from a values hash.  (Which is passed to us via the magic of JSON.)
    def initialize(properties={})
      @properties = properties
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
        @properties[$1] = params[0]
      else
        if @properties.has_key?(property)
          @properties[property]
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
        result_type = self.class.collection_name
        response = self.class.connection.post([create_fields].to_json)
      else
        result_type = self.class.resource_name
        response = connection.post(update_fields.to_json)
      end
      parsed = JSON.parse(response)
      if parsed[result_type].empty?
        @errors = parsed["warnings"]
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
    
    # Like +save+, but raises an ActsAsIcontact::RecordNotSaved exception if the save
    # failed.  The exception message contains the first error from iContact.
    def save!
      save or raise ActsAsIcontact::RecordNotSaved.new(errors)
    end
    
    # The first message from the +errors+ array.
    def error
      errors.first
    end
    
    # The warning messages sent back by iContact on a failed request.
    def errors
      @errors
    end
    
    # Returns an array of resources starting at the base.
    def self.find(type, options={})
      uri_extension = uri_component + build_query(options)
      response = base[uri_extension].get
      parsed = JSON.parse(response)
      case type
      when :first then
        self.new(parsed[collection_name].first) if parsed[collection_name]
      when :all then
        ResourceCollection.new(self, parsed)
      end
    end
    
    # Returns an array of resources starting at the base.
    def self.all
      find(:all)
    end
    
    # Returns the first account associated with this username.
    def self.first
      find(:first)
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
    
    # The base RestClient resource that this particular class nests from.  Starts with 
    # the resource connection at 'https://api.icontact.com/icp/' and works its way up.
    def self.base
      ActsAsIcontact.connection
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
    
    # The primary key field for this resource.  Used on updates.
    def self.primary_key
      resource_name + "Id"
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
    
    private
    def self.build_query(options={})
      return "" if options.empty?
      terms = options.collect{|k,v| "#{k}=#{URI.escape(v.to_s)}"}
      build = "?" + terms.join('&')
    end
  end
end