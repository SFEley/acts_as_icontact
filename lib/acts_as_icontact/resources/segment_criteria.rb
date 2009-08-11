module ActsAsIcontact
  # The list of criteria attached to every Segment.  Because of this intrinsic association, the usual #find methods don't
  # work; this collection _must_ be obtained using the individual segment's #criteria method.  
  # Unlike other subresources, SegmentCriteria can be created, modified, and saved.
  class SegmentCriteria < Subresource
    
    alias_method :segment, :parent
    
    # fieldName, operator, and values are required
    def self.required_on_create
      super + %w(fieldName operator values)
    end

    # Looks like 'criteria' is just a bit too strange for ActiveSupport to know singulars and plurals...
    def self.resource_name  # :nodoc:
      "criterion"
    end
    
    def self.collection_name  # :nodoc:
      "criteria"
    end
    
    # Uses criterionId as its ID.
    def id
      properties["criterionId"]
    end
    
    
    # operator must be one: eq, lt, lte, gt, gte, bet, notcontains, contains
    def validate_on_save(fields)
      operators = %w(eq lt lte gt gte bet notcontains contains)
      raise ActsAsIcontact::ValidationError, "operator must be one of: " + operators.join(', ') unless operators.include?(fields["operator"])
    end
 
  end
end