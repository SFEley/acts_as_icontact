module ActsAsIcontact
  class ResourceCollection < Enumerator
    attr_reader :total, :retrieved
    
    def initialize(klass, collection, forwardTo=nil)
      @klass = klass
      @forwardTo = forwardTo
      
      @collection = collection[klass.collection_name]
      # Get number of elements
      @retrieved = @collection.size
      @total = collection["total"]
      
      enumcode = Proc.new do |yielder|
        counter = 0
        while counter < @retrieved
          yielder.yield resource(@collection[counter])
          counter += 1
        end
      end
              
      super(&enumcode)
    end
    
    def [](index)
      resource(@collection[index]) if @collection[index]
    end
    
    # Calls "next" to kick off the enumerator.  This is more in line with what users would expect.
    def first
      self.rewind
      self.next
    end
    
    private 
    def resource(properties)
      if @forwardTo
        id = @forwardTo.primary_key
        @forwardTo.find(properties[id])
      else
        @klass.new(properties)
      end
    end
  end
end