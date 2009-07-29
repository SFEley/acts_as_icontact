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
          @icontact_in_progress = false  # Very primitive loop prevention
        end
      end

      def icontact_after_update
        unless @icontact_in_progress # Avoid callback loops
          c = find_contact_by_identity
          self.class.icontact_mappings.each do |rails, iContact|
            if (value = self.send(rails))
              ic = (iContact.to_s + '=').to_sym   # Blah. This feels like it should be easier.
              c.send(ic, value)
            end
          end
          c.save
          # No need to update the record this time; iContact field changes don't have side effects
        end
      end
      
      private
      def find_contact_by_identity
        im = self.class.icontact_identity_map
        if (im[1] == :contactId)
          ActsAsIcontact::Contact.find(self.send(im[0]))
        elsif (im[0] == :id)
          ActsAsIcontact::Contact.find(im[1] => id)
        else
          ActsAsIcontact::Contact.find(:email => self.send(im[0]))
        end
      rescue ActsAsIcontact::QueryError
        nil
      end
      
    end
  end
end
