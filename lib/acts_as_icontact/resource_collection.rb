module ActsAsIcontact
  class ResourceCollection < Enumerator
    attr_reader :total
    
    def initialize(klass, collection)
      @klass = klass
      @collection = collection[klass.collection_name]
      # Get number of elements
      @total = @collection.size
      
      enumcode = Proc.new do |yielder|
        counter = 0
        while counter < @total
          yielder.yield klass.new(@collection[counter])
          counter += 1
        end
      end
              
      super(&enumcode)
    end
    
    def [](index)
      @klass.new(@collection[index]) if @collection[index]
    end
    
  end
end