module ActsAsIcontact
  # The read-only set of statistics attached to every Message.  Because of this intrinsic association, the usual #find methods don't
  # work; this resource _must_ be obtained using the individual message's #statistics method.  Note also that 
  # this is a singleton resource, _not_ a collection.
  # Property updates and saving are also prohibited (returning a ReadOnlyError exception.)
  class MessageStatistics < Subresource
    include ReadOnly
    
    alias_method :message, :parent
    
    # This one's a little weird; remove scoped_find, and add scoped_first to retrieve just one record
    class <<self
      alias_method :scoped_find, :cannot_query
    end
    
    # Returns just one resource corresponding to the parent Message
    def self.scoped_first(parent)
      response = parent.connection[collection_name].get
      parsed = JSON.parse(response)
      self.new(parsed[collection_name].merge(:parent => parent))
    end
 
  end
end