module ActsAsIcontact
  # Predefined and user-supplied parameters for interfacing with iContact. Most of these are
  # required by the iContact API for authentication.
  module Config
    
    # Sets :production or :sandbox.  This changes the AppId and URL.
    def self.mode=(val)
      @mode = val
    end
    
    # Determines whether to return the sandbox or production AppId and URL.  
    # If not explicitly set, it will first look for an ICONTACT_MODE environment variable.
    # If it doesn't find one, it will attempt to detect a Rails or Rack environment; in either
    # case it will default to :production if RAILS_ENV or RACK_ENV is 'production', and :sandbox
    # otherwise.  If none of these conditions apply, it assumes :production.  (Because that
    # probably means someone's doing ad hoc queries.)
    def self.mode
      @mode ||= case
      when ENV["ICONTACT_MODE"] 
        ENV["ICONTACT_MODE"].to_sym
      when Object.const_defined?(:Rails)
        (ENV["RAILS_ENV"] == 'production' ? :production : :sandbox)
      when Object.const_defined?(:Rack)
        (ENV["RACK_ENV"] == 'production' ? :production : :sandbox)
      else
        :production
      end
    end
    
    # Passed in the header of every request as the *API-AppId:* parameter. You should not need
    # to change this.  Ever.
    def self.app_id
      @app_id ||= case mode
      when :sandbox
        "Ml5SnuFhnoOsuZeTOuZQnLUHTbzeUyhx" 
      when :production
        "IYDOhgaZGUKNjih3hl1ItLln7zpAtWN2"
      end
    end

    def self.app_id=(val)
      @app_id = val
    end
    
    # The API version that this code is designed to interface with.
    def self.api_version
      2.0
    end
    
    # Prefixed to the beginning of every API request.  You can override this if you have some special 
    # need (e.g. working against a testing server, or if iContact changes their URL and you have to
    # fix it before the gem gets updated), but for the most part you can leave it alone.
    def self.url
      @url ||= case mode
      when :production
        "https://app.icontact.com/icp/"
      when :sandbox
        "https://app.sandbox.icontact.com/icp/"
      end
    end
    
    # Overrides the base URL for the API request.  
    def self.url=(val)
      @url = val
    end
    
    # Used in the "Accept:" and "Content-Type:" headers of every API request.  Defaults to JSON, and
    # if you're simply using the gem methods there's no reason you should ever change this, as the
    # results are auto-parsed into Ruby structures.  But you can set it to text/xml if you want to.
    def self.content_type
      @content_type ||= "application/json"
    end
    
    # If you change this to anything other than application/json or text/xml you'll get an error.
    # So sayeth iContact; so say we all.
    def self.content_type=(val)
      case val
      when "text/xml"
        @content_type = val
      when "application/json"
        @content_type = val
      else
        raise ActsAsIcontact::ConfigError, "Content Type must be application/json or text/xml"
      end
    end
    
    # Required for every API request.  If you're using these methods in a Rails app, the recommended
    # way to set the username is in a Rails initializer file.  You can also set the ICONTACT_USERNAME
    # environment variable.
    def self.username
      @username ||= ENV['ICONTACT_USERNAME']
    end
    
    def self.username=(val)
      @username = val
    end

    # Required for every API request.  If you're using these methods in a Rails app, the recommended
    # way to set the password is in a Rails initializer file.  You can also set the ICONTACT_PASSWORD
    # environment variable.
    def self.password
      @password ||= ENV['ICONTACT_PASSWORD']
    end
    
    def self.password=(val)
      @password = val
    end
  end
end