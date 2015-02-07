require 'Huey'

def int?(str)
  (str =~ /\A\d+\Z/) != nil
end

def as_int(str)
  return str.to_i if str =~ /\A\d+\Z/
  str
end

class BulbController < ApplicationController
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

    should_commit = false

    if name != nil
      bulb.name = name
      should_commit = true
    end

    if on != nil
      if on.casecmp("true") == 0
        bulb.on = true
        should_commit = true
      elsif on.casecmp("false") == 0
        bulb.on = false
        should_commit = true
      end
    end

    if brightness != nil
      if int? brightness
        bri = brightness.to_i
        if bri >= 0 && bri <= 254
          bulb.bri = bri
          should_commit = true
        end
      end
    end

    if hue != nil
      if int? hue
        h = hue.to_i
        if h >= 0 && h <= 65535
          bulb.hue = h
          should_commit = true
        end
      end
    end

    if saturation != nil
      if int? saturation
        sat = saturation.to_i
        if sat >= 0 && sat <= 254
          bulb.sat = sat
          should_commit = true
        end
      end
    end

    if ct != nil
      if int? ct
        temp = ct.to_i
        if temp >= 154 && temp <= 500
          bulb.ct = temp 
          should_commit = true
        end
      end
    end

    if transition_time != nil
      if int? transition_time
        bulb.transitiontime = transition_time.to_i
        should_commit = true
      end
    end

    if rgb != nil
      if (rgb =~ /(^#[0-9A-F]{6}$)|(^#[0-9A-F]{3}$)/) != nil
        bulb.rgb = rgb
        should_commit = true
      end
    end

    bulb.commit if should_commit

    render :json => bulb
  end
end
