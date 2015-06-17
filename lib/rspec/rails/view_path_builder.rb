module  RSpec
  module Rails
    class ViewPathBuilder
      def initialize(route_set)
        @routes = route_set.routes
        self.class.send(:include, route_set.url_helpers)
      end

      def path_for(path_params)
        if route_exists?(path_params)
          url_for(path_params.merge(:only_path => true))
        end
      end

    private

      attr_reader :routes

      def route_exists?(path_params)
        path_keys = path_params.keys

        routes.any? do |route|
          actions_match = (route.defaults[:action] == path_params[:action])
          controllers_match = (route.defaults[:controller] == path_params[:controller])
          has_all_keys = route.required_keys.all? { |key| path_keys.include?(key) }

          actions_match && controllers_match && has_all_keys
        end
      end
    end
  end
end
