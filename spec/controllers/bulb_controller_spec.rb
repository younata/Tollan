require 'rails_helper'
require 'Huey'
require 'rspec_api_documentation/dsl'

resource 'Bulbs' do
  before do
    allow(Huey::Bulb).to receive(:all).and_return([{something: 'testing'}])
  end
  get "/bulbs" do
    example "It returns all of the bulbs" do
      do_request
      expect(response_status).to eq(200)
      parsed_body = JSON.parse(response_body)
      expect(parsed_body).to eq([{"something"=>"testing"}])
    end
  end

  get '/bulbs/:id' do
    before do
      allow(Huey::Bulb).to receive(:find).with(1).and_return({something: 'testing'})
      allow(Huey::Bulb).to receive(:find).with('light').and_return({something: 'testing'})
    end

    parameter :id, "The name (string) or id number (integer) for a given light"

    example "returns the bulb with id 1 when asked for bulb with id 1" do
      do_request({'id' => 1})
      expect(response_status).to eq(200)
      parsed_body = JSON.parse(response_body)
      expect(parsed_body).to eq({"something"=>"testing"})
    end

    example "returns the bulb with id 'light' when asked for bulb named 'light'" do
      do_request({'id' => 'light'})
      expect(response_status).to eq(200)
      parsed_body = JSON.parse(response_body)
      expect(parsed_body).to eq({"something"=>"testing"})
    end
  end

  put '/bulbs/:id' do
    bulb = nil
    before do
      bulb = instance_double('Huey::Bulb', :id => 1)
      allow(bulb).to receive(:on=)
      allow(bulb).to receive(:commit)
      allow(Huey::Bulb).to receive(:find).with(1).and_return(bulb)
    end
    example "Updates the bulb " do
      do_request({'id' => 1, 'on' => false})
      expect(bulb).to have_received(:on=).with(false)
      expect(bulb).to have_received(:commit)
    end
  end
end
