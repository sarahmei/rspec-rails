module  RSpec
  module Rails
    # Builds paths for view specs using a particular route set.
    class ViewPathBuilder
      def initialize(route_set)
        @routes = route_set.routes
        self.class.send(:include, route_set.url_helpers)
      end

      # Given a hash of parameters, build a view path, if possible.
      # Returns nil if no path can be built from the given params.
      #
      # @example
      #     # path can be built because all required params are present in the hash
      #     view_path_builder = ViewPathBuilder.new(::Rails.application.routes)
      #     view_path_builder.path_for({ :controller => 'posts', :action => 'show', :id => '54' })
      #     # => "/post/54"
      #
      # @example
      #     # path cannot be built because the params are missing a required element (:id)
      #     view_path_builder.path_for({ :controller => 'posts', :action => 'delete' })
      #     # => nil
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
          has_all_other_keys = route.required_keys.all? { |key| path_keys.include?(key) }

          actions_match && controllers_match && has_all_other_keys
        end
      end
    end
  end
end
