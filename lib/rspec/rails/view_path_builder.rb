module  RSpec
  module Rails
    class ViewPathBuilder
      def initialize(route_set)
        @routes = route_set.routes
        self.class.include(route_set.url_helpers)
      end

      def path_for(path_params)
        if route_exists?(path_params)
          url_for(path_params.merge(:only_path => true))
        end
      end

    private

      attr_reader :routes

      def route_exists?(path_params)
        routes.any? do |route|
          has_all_keys = route.required_keys.all? { |num| path_params.keys.include?(num) }
          action_match = route.defaults[:action] == path_params[:action]
          controller_match = route.defaults[:controller] == path_params[:controller]
          has_all_keys && action_match && controller_match
        end
      end
    end
  end
end
