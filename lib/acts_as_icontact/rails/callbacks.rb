module ActsAsIcontact
  module Rails
    module Callbacks
      
      protected
      # Called after a new record has been saved.  Creates a new contact in iContact.
      def icontact_after_create
        logger.debug "ActsAsIcontact creating contact for Rails ID: #{id}"
        c = ActsAsIcontact::Contact.new
        update_contact_from_rails_fields(c)
        if attempt_contact_save(c)
          @icontact_in_progress = true
          self.class.icontact_mappings.each do |rails, iContact|
            unless (value = c.send(iContact)).blank?
              r = (rails.to_s + '=').to_sym   # Blah. This feels like it should be easier.
              self.send(r, value)
            end
          end
          self.save
          # Subscribe the contact to any lists
          self.class.icontact_default_lists.each do |list|
            c.subscribe(list)
          end
          @icontact_in_progress = false  # Very primitive loop prevention
        end
      end

      # Called after an existing record has been updated.  Updates an existing contact in iContact if one
      # can be found; otherwise creates a new one.
      def icontact_after_update
        unless @icontact_in_progress # Avoid callback loops
          c = find_contact_by_identity or ActsAsIcontact::Contact.new
          update_contact_from_rails_fields(c)
          attempt_contact_save(c)
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
      
      def update_contact_from_rails_fields(contact)
        self.class.icontact_mappings.each do |rails, iContact|
          if (value = self.send(rails))
            ic = (iContact.to_s + '=').to_sym   # Blah. This feels like it should be easier.
            contact.send(ic, value)
          end
        end
      end
      
      def attempt_contact_save(contact)
        if self.class.icontact_exception_on_failure
          contact.save!
          logger.info "ActsAsIcontact contact created. Rails ID: #{id}; iContact ID: #{contact.id}"
          true
        else
          if contact.save
            logger.info "ActsAsIcontact contact created. Rails ID: #{id}; iContact ID: #{contact.id}"
            true
          else
            logger.warn "ActsAsIcontact contact creation failed! iContact says: #{contact.error}"
            false
          end
        end
      end
        
    end
  end
end
