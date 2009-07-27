module ActsAsIcontact
  module Rails
    module Callbacks
      
      protected
      # Called after a new record has been saved.  Creates a new contact in iContact.
      def icontact_after_create
        c = ActsAsIcontact::Contact.new
        self.class.icontact_mappings.each do |rails, iContact|
          if (value = self.send(rails))
            ic = (iContact.to_s + '=').to_sym   # Blah. This feels like it should be easier.
            c.send(ic, value)
          end
        end
        if c.save
          # Update with iContact fields returned
          @icontact_in_progress = true
          self.class.icontact_mappings.each do |rails, iContact|
            unless (value = c.send(iContact)).blank?
              r = (rails.to_s + '=').to_sym   # Blah. This feels like it should be easier.
              self.send(r, value)
            end
          end
          self.save
        end
        
      end
      
    end
  end
end
