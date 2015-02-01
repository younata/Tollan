require 'Huey'

class HueController < ApplicationController
  def index
    render :json => Huey::Bulb.all
  end

  def show
  end

  def update
  end
end
