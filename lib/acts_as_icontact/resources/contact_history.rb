module ActsAsIcontact
  # The read-only list of actions attached to every Contact.  Because of this intrinsic association, the usual #find methods don't
  # work; contact history _must_ be obtained using the individual contact's #history method.  
  # Property updates and saving are also prohibited (returning a ReadOnlyError exception.)
  class ContactHistory < Subresource
    include ReadOnly
    
    alias_method :contact, :parent
 
  protected
    # An oddball resource class; iContact's URL for it is 'actions', not 'contact_histories'.
    def self.resource_name
      'action'
    end
    
  end
end