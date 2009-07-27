module ActsAsIcontact
  module Rails
    module ClassMethods
      module Mappings
        
        ICONTACT_DEFAULT_MAPPINGS = {
          :contactId => [:icontact_id, :icontactId],
          :email => [:email, :email_address, :eMail, :emailAddress],
          :firstName => [:firstName, :first_name, :fname],
          :lastName => [:lastName, :last_name, :lname], 
          :street => [:street, :street1, :address, :address1],
          :street2 => [:street2, :address2],
          :city => [:city],
          :state => [:state, :province, :state_or_province],
          :postalCode => [:postalCode, :postal_code, :zipCode, :zip_code, :zip],
          :phone => [:phone, :phoneNumber, :phone_number],
          :fax => [:fax, :faxNumber, :fax_number],
          :business => [:business, :company, :companyName, :company_name, :businessName, :business_name],
          :status => [:icontact_status, :icontactStatus],
          :createDate => [:icontact_created, :icontactCreated, :icontact_create_date, :icontactCreateDate],
          :bounceCount => [:icontact_bounces, :icontactBounces, :icontact_bounce_count, :icontactBounceCount]
        }

        # A hash containing the final list of iContact-to-Rails mappings.  The mappings take into account both
        # analysis of existing field names and explicit mappings on the `acts_as_icontact` macro line.
        def icontact_mappings
          @icontact_mappings
        end
        
        # A two-element array indicating the association used to uniquely identify this record between Rails and iContact.
        # The first element is the Rails field; the second element is the iContact field.
        # First uses whatever field maps the contactId; if none, looks for a mapping from the Rails ID.  Uses the email address
        # mapping (which is required) as a last resort.
        def icontact_identity_map
          icontact_mappings.rassoc(:contactId) or icontact_mappings.assoc(:id) or icontact_mappings.rassoc(:email)
        end
        
        protected
        
        # Sets up the mapping hash from iContact fields to Rails fields.
        def set_mappings(options)
          @icontact_mappings = {}
          set_default_mappings
          set_custom_field_mappings
          @icontact_mappings.merge!(options)
        end
        
        private
        def set_default_mappings
          ICONTACT_DEFAULT_MAPPINGS.each do |iContactField, candidates|
            candidates.each do |candidate|
              if rails_field?(candidate)
                @icontact_mappings[candidate] = iContactField
                break
              end
            end
          end
        end
        
        def set_custom_field_mappings
          @icontact_custom_fields ||= CustomField.list
          @icontact_custom_fields.each do |field|
            f = field.to_sym
            @icontact_mappings[f] = f if rails_field?(f)
          end
        end
        
        def rails_field?(field)
          column_names.include?(field.to_s) or instance_methods.include?(field) 
        end
      end
    end
  end
end
