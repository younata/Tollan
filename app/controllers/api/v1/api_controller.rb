module Api
  module V1
    class ApiController < ApplicationController
      protect_from_forgery with: :null_session
      before_filter :restrict_access

      private
      def restrict_access
        authenticate_or_request_with_http_token do |token, options|
          User.exists?(api_token: token)
        end
      end
    end
  end
end
