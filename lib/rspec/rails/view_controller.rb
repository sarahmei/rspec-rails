module RSpec
  module Rails
    module ViewController
      def self.included(_klass)
        ::ActionView::TestCase::TestController.send(:include, InstanceMethods)
      end

      module InstanceMethods
        def extra_params
          @extra_params ||= {}
        end

        def extra_params=(hash)
          @extra_params = hash
          self.request.path =
            ViewPathBuilder.new(::Rails.application.routes).path_for(
              extra_params.merge(self.request.path_parameters)
            )
        end
      end
    end
  end
end
