require 'Huey'
require 'api_helper'

class BulbController < ApplicationController
  def index
    @bulbs = Huey::Bulb.all
  end

  def view
    @bulb = Huey::Bulb.find(ApiHelper::as_int params[:id])
  end
end
