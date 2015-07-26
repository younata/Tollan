require 'huey'
require 'api_helper'
include BulbHelper

module Api
  module V1
    class BulbController < ApiController
      def index
        render :json => Huey::Bulb.all
      end

      def show
        id = ApiHelper::as_int(params[:id])
        render :json => Huey::Bulb.find(id)
      end

      def update
        id = params[:id]
        name = params[:name]
        on = params[:on]
        brightness = params[:brightness]
        hue = params[:hue] # hue hue hue
        saturation = params[:saturation]
        ct = params[:ct]
        transition_time = params[:transition_time]
        rgb = params[:rgb]

        render :json => update_bulb(id, name, on, brightness, hue, saturation, ct, transition_time, rgb)
      end
    end
  end
end
