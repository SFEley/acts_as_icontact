module ActsAsIcontact
  # The read-only list of bounces attached to every Message.  Because of this intrinsic association, the usual #find methods don't
  # work; this collectin _must_ be obtained using the individual message's #bounces method.  
  # Property updates and saving are also prohibited (returning a ReadOnlyError exception.)
  class MessageBounces < Subresource
    include ReadOnly
    
    alias_method :message, :parent
    
    # Retrieves the contact pointed to by this message record's contactId.
    def contact
      @contact ||= ActsAsIcontact::Contact.find(contactId.to_i) if contactId.to_i > 0
    end
 
  end
end