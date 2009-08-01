module ActsAsIcontact
  module Rails
    module ClassMethods
      module Macro

        # The core macro for ActsAsIcontact's Rails integration.  Establishes callbacks to keep Rails models in
        # sync with iContact.  See the README for more on what it does.
        def acts_as_icontact(options = {})
          logger.info "Initializing ActsAsIcontact module..."

          # Fail on exceptions?
          @icontact_exception_on_failure = options.delete(:exception_on_failure) || false
          logger.info "ActsAsIcontact #{'NOT ' unless @icontact_exception_on_failure}returning exceptions on failure."
          
          # Set up lists for autosubscribe
          set_default_lists(options.delete(:list), options.delete(:lists))
          logger.info "ActsAsIcontact autosubscribe lists: #{icontact_default_lists.join}" unless icontact_default_lists.empty?
          
          # Set up field mappings
          set_mappings(options)
          logger.info "ActsAsIcontact field mappings: #{icontact_mappings}"
          
          # If we haven't flaked out so far, we must be doing okay.  Make magic happen.
          include ActsAsIcontact::Rails::Callbacks
          after_create :icontact_after_create
          after_update :icontact_after_update
          logger.info "ActsAsIcontact callbacks created.  Have Fun."
        end
        
        def icontact_exception_on_failure
          @icontact_exception_on_failure
        end
      end
    end
  end
end
