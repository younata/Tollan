require 'Huey'

def as_int(str)
  return str.to_i if str =~ /\A\d+\Z/
  str
end

class HueController < ApplicationController
  def index
    begin
      render :json => Huey::Bulb.all
    rescue Exception => e
      render :json => {error: e.message}
    end
  end

  def show
    id = as_int(params[:id])
    begin
      render :json => Huey::Bulb.find(id)
    rescue
      render :json => {error: e.message}
    end
  end

  def update
    begin
      bulb = Huey::Bulb.find(as_int(params[:id]))

      name = params[:name]
      on = params[:on]
      brightness = params[:brightness]
      hue = params[:hue] # hue hue hue
      saturation = params[:saturation]
      ct = params[:ct]
      transition_time = params[:transition_time]
      rgb = params[:rgb]

      if name != nil
        bulb.name = name
      end

      if on != nil
        bulb.on = on
      end

      if brightness != nil
        bulb.bri = brightness
      end

      if hue != nil
        bulb.hue = hue
      end

      if saturation != nil
        bulb.sat = sat
      end

      if ct != nil
        bulb.ct = ct
      end

      if transition_time != nil
        bulb.transitiontime = transition_time
      end

      if rgb != nil
        bulb.rgb = rgb
      end

      bulb.commit

      render :json => bulb
    rescue Exception => e
      render :json => {error: e.message}
    end
  end
end
