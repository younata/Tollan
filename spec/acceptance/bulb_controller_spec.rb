require 'acceptance_helper'
require 'Huey'

resource 'Bulbs' do
  obj = {"id"=> 3, "changes"=> {}, "name"=> "Hue Lamp 2", "on"=> false, "bri"=> 194, "hue"=> 15051, "sat"=> 137, "xy"=> [0.4, 0.4], "ct"=> 359, "transitiontime"=> nil, "colormode"=> "ct", "effect"=> "none", "reachable"=> true, "alert"=> "none"}

  get "/bulbs" do
    before do
      allow(Huey::Bulb).to receive(:all).and_return([obj])
    end
    example_request "Fetching all of the bulbs" do
      explanation "It fetches all of the bulbs and returns them as an array of json objects"
      expect(response_status).to eq(200)
      parsed_body = JSON.parse(response_body)
      expect(parsed_body).to eq([obj])
    end
  end

  get '/bulbs/:id' do
    before do
      allow(Huey::Bulb).to receive(:find).with(1).and_return(obj)
      allow(Huey::Bulb).to receive(:find).with('light').and_return(obj)
    end

    parameter :id, "The name (string) or id number (integer) for a given light", :required => true

    example "Fetching a single bulb by id number" do
      explanation "It fetches a single bulb given the bulb's id number (as an integer)"
      do_request(id: 1)
      expect(response_status).to eq(200)
      parsed_body = JSON.parse(response_body)
      expect(parsed_body).to eq(obj)
    end

    example "Fetching a single bulb by name" do
      explanation "It fetches a single bulb given the bulb's name (as a string)"
      do_request(id: 'light')
      expect(response_status).to eq(200)
      parsed_body = JSON.parse(response_body)
      expect(parsed_body).to eq(obj)
    end
  end

  put '/bulbs/:id' do
    bulb = nil
    before do
      bulb = instance_double('Huey::Bulb', :id => 1)
      allow(bulb).to receive(:on=)
      allow(bulb).to receive(:bri=)
      allow(bulb).to receive(:hue=)
      allow(bulb).to receive(:sat=)
      allow(bulb).to receive(:ct=)
      allow(bulb).to receive(:transitiontime=)
      allow(bulb).to receive(:rgb=)
      allow(bulb).to receive(:commit)
      allow(Huey::Bulb).to receive(:find).with(1).and_return(bulb)
    end

    parameter :id, "The name (string) or id number (integer) for a given light", :required => true
    parameter :on, "Indicates whether to turn the bulb on or off, this does not affect connectivity. Expected as a bool (either 'true', or 'false', case insensitive)."
    parameter :brightness, "Sets the brightness for a bulb, between 0 and 254. Setting brightess to 0 does not turn the bulb off"
    parameter :hue, "Sets the hue for a bulb, between 0 and 65535. Multiply the hue degree by 182 to get this"
    parameter :saturation, "Sets the saturation value for the bulb, between 0 and 254"
    parameter :ct, "Sets the color temperature for the bulb, expressed in mireds (http://en.wikipedia.org/wiki/Mired), is an integer between 154 and 500"
    parameter :transition_time, "Sets the time to transition from one state to another, 0 is instantaneous. Tenths of a second expressed as integers (e.g. 10 is 1 second, 15 is 1.5 seconds, etc.)"
    parameter :rgb, "Convenience method, pass in HTML hex values (e.g. '#777', '#FF88FF'. Include preceding '#'), and will automatically convert to hue/saturation"

    example 'Updating a bulb' do
      do_request(id: 1, on: false, brightness: 200, hue: 1024, saturation: 127, ct: 200, transition_time: 0, rgb: "#F30")
      explanation "It fetches a single bulb given the bulb's name or id number, and updates it with the given values"

      expect(bulb).to have_received(:on=).with(false)
      expect(bulb).to have_received(:bri=).with(200)
      expect(bulb).to have_received(:hue=).with(1024)
      expect(bulb).to have_received(:sat=).with(127)
      expect(bulb).to have_received(:ct=).with(200)
      expect(bulb).to have_received(:transitiontime=).with(0)
      expect(bulb).to have_received(:rgb=).with("#F30")
      expect(bulb).to have_received(:commit)
    end

    context 'Updating the bulb\'s on value' do
      example 'Updating the bulb with a valid on value', :document => false do
        do_request(id: 1, on: false)

        expect(bulb).to have_received(:on=).with(false)
        expect(bulb).to have_received(:commit)
      end

      example 'Updating the bulb with an invalid on value', :document => false do
        do_request(id: 1, on: 3)

        expect(bulb).to_not have_received(:on=)
        expect(bulb).to_not have_received(:commit)
      end
    end

    context 'Updating the bulb\'s brightness value' do
      example 'Updating the bulb with a valid brightness value', :document => false do
        do_request(id: 1, brightness: 200)

        expect(bulb).to have_received(:bri=).with(200)
        expect(bulb).to have_received(:commit)
      end

      example 'Updating the bulb with an invalid brightness value', :document => false do
        do_request(id: 1, brightness: 300)

        expect(bulb).to_not have_received(:bri=).with(300)
        expect(bulb).to_not have_received(:commit)
      end
    end

    context 'Updating the bulb\'s hue value' do
      example 'Updating the bulb with a valid hue value', :document => false do
        do_request(id: 1, hue: 1024)

        expect(bulb).to have_received(:hue=).with(1024)
        expect(bulb).to have_received(:commit)
      end

      example 'Updating the bulb with an invalid hue value', :document => false do
        do_request(id: 1, hue: 65536)

        expect(bulb).to_not have_received(:hue=).with(65536)
        expect(bulb).to_not have_received(:commit)
      end
    end

    context 'Updating the bulb\'s saturation value' do
      example 'Updating the bulb with a valid saturation value', :document => false do
        do_request(id: 1, saturation: 127)

        expect(bulb).to have_received(:sat=).with(127)
        expect(bulb).to have_received(:commit)
      end

      example 'Updating the bulb with an invalid saturation value', :document => false do
        do_request(id: 1, saturation: 400)

        expect(bulb).to_not have_received(:sat=).with(400)
        expect(bulb).to_not have_received(:commit)
      end
    end

    context 'Updating the bulb\'s color temperature value' do
      example 'Updating the bulb with a valid saturation value', :document => false do
        do_request(id: 1, ct: 250)

        expect(bulb).to have_received(:ct=).with(250)
        expect(bulb).to have_received(:commit)
      end

      example 'Updating the bulb with an invalid saturation value', :document => false do
        do_request(id: 1, ct: 100)

        expect(bulb).to_not have_received(:ct=).with(100)
        expect(bulb).to_not have_received(:commit)
      end
    end

    context 'Updating the bulb\'s transition_time value' do
      example 'Updating the bulb with a valid transition_time value', :document => false do
        do_request(id: 1, transition_time: 10)

        expect(bulb).to have_received(:transitiontime=).with(10)
        expect(bulb).to have_received(:commit)
      end

      example 'Updating the bulb with a valid transition_time value', :document => false do
        do_request(id: 1, transition_time: "some string")

        expect(bulb).to_not have_received(:transitiontime=).with(10)
        expect(bulb).to_not have_received(:commit)
      end
    end

    context 'Updating the bulb\'s rgb value' do
      example 'Updating the bulb with a valid rgb value', :document => false do
        do_request(id: 1, rgb: "#FFFFFF")

        expect(bulb).to have_received(:rgb=).with("#FFFFFF")
        expect(bulb).to have_received(:commit)
      end

      example 'Updating the bulb with a valid (short) rgb value', :document => false do
        do_request(id: 1, rgb: "#FFF")

        expect(bulb).to have_received(:rgb=).with("#FFF")
        expect(bulb).to have_received(:commit)
      end

      example 'Updating the bulb with an invalid rgb value', :document => false do
        do_request(id: 1, rgb: "blah")

        expect(bulb).to_not have_received(:rgb=).with("blah")
        expect(bulb).to_not have_received(:commit)
      end
    end
  end
end
