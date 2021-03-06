require 'huey'
require 'api_helper'
require 'session_helper'

class BulbController < ApplicationController
  include SessionHelper
  include BulbHelper

  before_action :logged_in_user

  def index
    @bulbs = Huey::Bulb.all
  end

  def view
    @bulb = Huey::Bulb.find(ApiHelper::as_int params[:id])
  end

  def update
    id = params[:id]
    name = params[:bulb][:name]
    on = params[:bulb][:on]
    brightness = params[:bulb][:brightness]
    hue = params[:bulb][:hue]
    saturation = params[:bulb][:saturation]
    color_temp = params[:bulb][:color_temp]
    transition_time = params[:bulb][:transition_time]
    rgb = params[:bulb][:rgb]

    update_bulb(id, name, on, brightness, hue, saturation, color_temp, transition_time, rgb)
    redirect_to "/bulbs/#{id}"
  end

  private

  def logged_in_user
    if current_user.nil?
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    elsif current_user.api_token.nil?
      flash[:danger] = 'Insufficient privileges'
      redirect_to '/'
    end
  end
end
