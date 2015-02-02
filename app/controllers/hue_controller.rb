require 'Huey'

def as_int(str)
  return str.to_i if str =~ /\A\d+\Z/
  str
end

class HueController < ApplicationController
  def index
    render :json => Huey::Bulb.all
  end

  def show
    id = as_int(params[:id])
    render :json => Huey::Bulb.find(id)
  end

  def update
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
  end
end
