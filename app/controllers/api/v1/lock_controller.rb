require 'lockitron'
require 'api_helper'
include LockHelper

module Api
  module V1
    class LockController < ApiController
      def index
        render :json => locks()
      end

      def show
        render :json => lock_json(lock_by_id(params[:id]))
      end

      def update
        render :json => set_lock_by_id(params[:id], params[:lock])
      end

      private

      def locks
        @user ||= lock_user("")
        locks = @user.locks.collect do |lock|
          lock_json(lock)
        end
      end

      def lock_by_id(id)
        @user ||= lock_user("")
        @user.locks.select { |l| l.uuid == id }.first
      end

      def set_lock_by_id(id, to_lock)
        update_lock(lock_by_id(id), to_lock)
      end
    end
  end
end
