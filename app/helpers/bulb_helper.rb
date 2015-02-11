require 'Huey'

require 'api_helper'

module BulbHelper
  def update_bulb(id, name, on, brightness, hue, saturation, ct, transition_time, rgb)
    bulb = Huey::Bulb.find(ApiHelper::as_int(id))

    should_commit = false

    if name != nil && bulb.name != name
      bulb.name = name
      should_commit = true
    end

    if on != nil
      if on.casecmp("true") == 0 && !bulb.on
        bulb.on = true
        should_commit = true
      elsif on.casecmp("false") == 0 && bulb.on
        bulb.on = false
        should_commit = true
      end
    end

    if brightness != nil
      if ApiHelper::int? brightness
        bri = brightness.to_i
        if bri >= 0 && bri <= 254 && bulb.bri != bri
          bulb.bri = bri
          should_commit = true
        end
      end
    end

    if hue != nil
      if ApiHelper::int? hue
        h = hue.to_i
        if h >= 0 && h <= 65535 && bulb.hue != h
          bulb.hue = h
          should_commit = true
        end
      end
    end

    if saturation != nil
      if ApiHelper::int? saturation
        sat = saturation.to_i
        if sat >= 0 && sat <= 254 && bulb.sat != sat
          bulb.sat = sat
          should_commit = true
        end
      end
    end

    if ct != nil
      if ApiHelper::int? ct
        temp = ct.to_i
        if temp >= 154 && temp <= 500 && bulb.ct != temp
          bulb.ct = temp 
          should_commit = true
        end
      end
    end

    if transition_time != nil
      if ApiHelper::int? transition_time
        trans_time = transition_time.to_i
        if bulb.transitiontime != trans_time
          bulb.transitiontime = trans_time
          should_commit = true
        end
      end
    end

    if rgb != nil
      if (rgb =~ /(^#[0-9A-F]{6}$)|(^#[0-9A-F]{3}$)/) != nil && bulb.rgb != rgb
        bulb.rgb = rgb
        should_commit = true
      end
    end

    bulb.commit if should_commit
    bulb
  end
end
