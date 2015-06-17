module RSpec
  module Rails
    module Extensions
      module ViewController
        def self.included(_klass)
          ::ActionView::TestCase::TestController.include(InstanceMethods)
        end

        module InstanceMethods
          def extra_params
            @extra_params ||= {}
          end

          def extra_params=(hash)
            @extra_params = hash
            self.request.path = url_for({only_path: true}.merge(extra_params.merge(self.request.path_parameters)))
          end
        end
      end
    end
  end
end
