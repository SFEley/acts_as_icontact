module ActsAsIcontact
  
  # Overrides methods to make a resource class read-only.  Replaces property assignments and save methods with exceptions.
  module ReadOnly
    
    # Properties of this class are read-only.
    def method_missing(method, *params)
      raise ActsAsIcontact::ReadOnlyError, "#{self.class.readable_name} is read-only!" if method.to_s =~ /(.*)=$/ 
      super
    end
    
    # Replace save methods with an exception
    def cannot_save(*arguments)
      raise ActsAsIcontact::ReadOnlyError, "Contact History is read-only!"
    end
    alias_method :save, :cannot_save
    alias_method :save!, :cannot_save
    
  end
  
end