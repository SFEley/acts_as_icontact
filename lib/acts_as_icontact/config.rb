module ActsAsIcontact
  # Predefined and user-supplied parameters for interfacing with iContact. Most of these are
  # required by the iContact API for authentication.
  module Config
    # Passed in the header of every request as the *API-AppId:* parameter. You should not need
    # to change this.  Ever.
    def self.app_id
      "Ml5SnuFhnoOsuZeTOuZQnLUHTbzeUyhx"
    end
    
    # The API version that this code is designed to interface with.
    def self.api_version
      2.0
    end
    
    # Prefixed to the beginning of every API request.  You can override this if you have some special
    # need (e.g. working against a testing server, or if iContact takes their API out of beta and 
    # changes the URI before the gem gets updated), but for the most part you can leave it alone.
    def self.url
      @url ||= "https://app.beta.icontact.com/icp/"
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
    # way to set the usenrame is in a Rails initializer file.  You can also set the ICONTACT_USERNAME
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