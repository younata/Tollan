require 'Huey'

class BulbController < ApplicationController
  def index
    @bulbs = Huey::Bulb.all
  end

  def view
    @bulb = Huey::Bulb.find(params[:id])
  end
end
