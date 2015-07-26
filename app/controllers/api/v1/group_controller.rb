require 'huey'
require 'api_helper'

module Api
  module V1
    class GroupController < ApiController
      def index
        render :json => Huey::Group.all
      end

      def show
        id = ApiHelper::as_int(params[:id])
        render :json => Huey::Group.find(id)
      end

      def create
      end

      def update
      end

      def delete
      end
    end
  end
end
