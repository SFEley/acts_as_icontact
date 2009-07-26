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
        
        protected
        # Sets up the mapping hash from iContact fields to Rails fields.
        def set_mappings(options)
          @icontact_mappings = {}
          ICONTACT_DEFAULT_MAPPINGS.each do |key, value|
            value.each do |field|
              if column_names.include?(field.to_s) or instance_methods.include?(field) 
                @icontact_mappings[field] = key
                break
              end
            end
          end
          @icontact_mappings.merge!(options)
        end
      end
    end
  end
end
