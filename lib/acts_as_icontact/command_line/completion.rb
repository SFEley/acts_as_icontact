require 'bond'

module Bond
      
  module Actions
    # ActsAsIcontact resource classes
    def icontact_classes(input)
      ActsAsIcontact::Resource.subclasses.map{|c| c.sub(/ActsAsIcontact\:\:/,'')}
    end
    
    
    # ActsAsIcontact resource properties
    def icontact_properties(input)
      receiver = ActsAsIcontact.instance_eval(input.matched[1])
      if receiver.respond_to?(:property_names)
        (receiver.property_names + receiver.methods - Object.methods).sort
      else
        (receiver.methods - Object.methods).sort
      end
    end
    
  end
  debrief(:eval_binding => binding)
  debrief(:default_search => :ignore_case)
  debrief(:default_mission => :icontact_classes)
  
end

# Complete ActsAsIcontact resources
Bond.complete(:on=>/([A-Z][^.\s]*)+$/, :action=>:icontact_classes)

# ActsAsIcontact resource class methods
Bond.complete(:on=>/([A-Z][^.\s]*)\.([^.\s]*)$/, :search => false) do |input|  
  receiver = ActsAsIcontact.const_get(input.matched[1].to_sym)
  methods = (receiver.methods - Class.methods).sort
  methods.grep(/^#{input.matched[2]}/i).collect{|m| "#{input.matched[1]}.#{m}"}
end
  

# ActsAsIcontact resource properties
Bond.complete(:on=>/([^.\s]+)\.([^.\s]*)$/, :search => false) do |input|
  receiver = ActsAsIcontact.instance_eval(input.matched[1])
  if receiver.respond_to?(:property_names)
    methods = (receiver.property_names + receiver.methods - Object.methods).sort
  else
    methods = (receiver.methods - Object.methods).sort
  end
  methods.grep(/^#{input.matched[2]}/i).collect{|m| "#{input.matched[1]}.#{m}"}  
end

