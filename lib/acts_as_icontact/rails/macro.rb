module ActsAsIcontact
  module Rails
    module ClassMethods
      module Macro

        # The core macro for ActsAsIcontact's Rails integration.  Establishes callbacks to keep Rails models in
        # sync with iContact.  See the README for more on what it does.
        def acts_as_icontact(options = {})
          # Fail on exceptions?
          @icontact_exception_on_failure = options.delete(:exception_on_failure) || false
          
          # Combines :list and :lists parameters into one array
          @icontact_default_lists = []
          @icontact_default_lists << options.delete(:list) if options.has_key?(:list)
          @icontact_default_lists += options.delete(:lists) if options.has_key?(:lists)
          
          # Set up field mappings
          set_mappings(options)
          
          # If we haven't flaked out so far, we must be doing okay.  Make magic happen.
          include ActsAsIcontact::Rails::Callbacks
          after_create :icontact_after_create
          after_update :icontact_after_update
        end

      end
    end
  end
end
