require 'Huey'
require 'api_helper'
require 'session_helper'

class BulbController < ApplicationController
  include SessionHelper

  before_action :logged_in_user

  def index
    @bulbs = Huey::Bulb.all
  end

  def view
    @bulb = Huey::Bulb.find(ApiHelper::as_int params[:id])
  end

  private

  def logged_in_user
    unless logged_in?
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end
end
