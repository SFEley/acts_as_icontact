module ActsAsIcontact
  module Rails
    module ClassMethods
      module Lists
        
        # The lists that each new contact will be subscribed to upon creation.  Set by the :list and :lists 
        # options to acts_as_icontact.
        def icontact_default_lists
          @icontact_default_lists
        end
        
        protected
        
        # Builds an array of any lists in the :list or :lists parameter.
        def set_default_lists(list, lists)
          # Combines :list and :lists parameters into one array
          @icontact_default_lists = []
          @icontact_default_lists << list if list
          @icontact_default_lists += lists if lists
        end

      end
    end
  end
end
