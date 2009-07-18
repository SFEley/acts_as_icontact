require 'activesupport'
require 'uri'

module ActsAsIcontact
  # Base class for shared functionality between iContact resources.  Supports getting, finding, saving,
  # all that fun stuff. 
  class Resource
    
    # Creates a new resource object from a values hash.  (Which is passed to us via the magic of JSON.)
    def initialize(properties=nil)
      @properties = properties
    end
    
    # Enables keys from the iContact resource to act as attribute methods.
    def method_missing(method, *params)
      property = method.to_s
      if @properties.has_key?(property)
        @properties[property]
      else
        raise
      end
    end
    
    # Returns an array of resources starting at the base.
    def self.find(type, options={})
      uri_extension = uri_component + build_query(options).to_s
      response = base[uri_extension].get
      parsed = JSON.parse(response)
      parsed[collection_name].collect{|r| self.new(r)}
    end
    
    # Returns an array of resources starting at the base.
    def self.all
      find(:all)
    end
    
    # Returns the first account associated with this username.
    def self.first
      all.first
    end
    
    protected
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
    
    private
    def self.build_query(options={})
      return nil if options.empty?
      terms = options.collect{|k,v| "#{k}=#{URI.escape(v.to_s)}"}
      "?" + terms.join('&')
    end
  end
end