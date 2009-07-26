module ActsAsIcontact
  module Rails
    module ClassMethods
      module Macro

        # The core macro for ActsAsIcontact's Rails integration.  Establishes callbacks to keep Rails models in
        # sync with iContact.  See the README for more on what it does.
        def acts_as_icontact(options = {})
          true
        end

      end
    end
  end
end
