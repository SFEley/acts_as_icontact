module ActsAsIcontact
  # Thrown when a configuration value isn't provided or is invalid.
  class ConfigError < StandardError; end
  
  # Thrown when a resource calls save! and fails. Contains the +.errors+ array from
  # the resource.
  class RecordNotSaved < StandardError
    attr_reader :errors
    
    def initialize(errors = [])
      @errors = errors
    end
    
    def message
      errors.first
    end
    alias_method :error, :message
  end
end