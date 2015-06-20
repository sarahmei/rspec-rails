module RSpec
  module Rails
    # Methods added to ActionView::TestCase::TestController, only in view specs
    module ViewController
      def self.included(_klass)
        ::ActionView::TestCase::TestController.send(:include, ExtraParamsAccessors)
      end

      # Methods that are added to ActionView::TestCase::TestController
      # and exposed in view specs as methods on `controller`.
      module ExtraParamsAccessors
        # Use to set any extra parameters that rendering a URL for this view
        # would need.
        #
        # @example
        #
        #     # In "spec/views/widgets/show.html.erb_spec.rb":
        #     before do
        #       widget = Widget.create!(:name => "slicer")
        #       controller.extra_params = { :id => widget.id }
        #     end
        def extra_params=(hash)
          @extra_params = hash
          request.path =
            ViewPathBuilder.new(::Rails.application.routes).path_for(
              extra_params.merge(request.path_parameters)
            )
        end

        # Use to read extra parameters that are set in the view spec.
        #
        # @example
        #
        #     # After the before in the above example:
        #     controller.extra_params
        #     # => { :id => 4 }
        def extra_params
          @extra_params ||= {}
        end
      end
    end
  end
end
