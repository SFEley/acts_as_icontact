module ActsAsIcontact
  class Segment < Resource
    
    # Name and listId are required
    def self.required_on_create
      super << 'listId' << 'name'
    end

    # Name and listId are required
    def self.required_on_update
      super << 'name'
    end
    
    # Cannot pass listId when updating
    def self.never_on_update
      ['listId']
    end
    
    # Searches on segment name.
    def self.find_by_string(value)
      first(:name => value)
    end
    
       
    # Returns the list to which this segment is bound.
    def list
      @list ||= ActsAsIcontact::List.find(listId.to_i) if (listId.to_i) > 0
    end
    
    # Returns a collection of SegmentCriteria resources for this segment.  The usual iContact search options (limit, offset, search terms, etc.) can be passed.
    def criteria(options={})
      @criteria ||= ActsAsIcontact::SegmentCriteria.scoped_find(self, options)
    end
  end
end