require 'acceptance_helper'
require 'Huey'

resource 'Bulbs' do
  obj = {"id"=> 3, "changes"=> {}, "name"=> "Hue Lamp 2", "on"=> false, "bri"=> 194, "hue"=> 15051, "sat"=> 137, "xy"=> [0.4, 0.4], "ct"=> 359, "transitiontime"=> nil, "colormode"=> "ct", "effect"=> "none", "reachable"=> true, "alert"=> "none"}

  get "/bulbs" do
    before do
      allow(Huey::Bulb).to receive(:all).and_return([obj])
    end
    example "Fetching all of the bulbs" do
      do_request
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

    parameter :id, "The name (string) or id number (integer) for a given light"

    example "Fetching a single bulb by id number" do
      do_request(id: 1)
      expect(response_status).to eq(200)
      parsed_body = JSON.parse(response_body)
      expect(parsed_body).to eq(obj)
    end

    example "Fetching a single bulb by name" do
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

    example 'Updating the bulb' do
      do_request(id: 1, on: false, brightness: 200, hue: 1024, saturation: 127, ct: 200, transition_time: 0, rgb: "#F30")

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