require 'Huey'

class HueController < ApplicationController
  def index
    Huey::Bulb.all
  end

  def show
  end

  def update
  end
end
