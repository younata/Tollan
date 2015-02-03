require 'rails_helper'
require 'Huey'

RSpec.describe BulbController, :type => :controller do
  before (:each) do
  end
  describe "GET index" do
    before (:each) do
      allow(Huey::Bulb).to receive(:all).and_return([{something: 'testing'}])
      get :index
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the lights as a json" do
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to eq([{"something"=>"testing"}])
    end
  end

  describe "GET show" do
    before (:each) do
      allow(Huey::Bulb).to receive(:find).with(1).and_return({something: 'testing'})
      get :show, id: 1
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the lights as a json" do
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to eq({"something"=>"testing"})
    end
  end

  describe "PUT update" do
    bulb = nil
    before (:each) do
      bulb = instance_double('Huey::Bulb', :id => 1)
      allow(bulb).to receive(:on=)
      allow(bulb).to receive(:commit)
      allow(Huey::Bulb).to receive(:find).with(1).and_return(bulb)
      get :update, id: 1, on: false
    end
    it "returns http success" do
      expect(response).to have_http_status(200)
    end
    it "updates the bulb status" do
      expect(bulb).to have_received(:on=).with(false)
      expect(bulb).to have_received(:commit)
    end
  end
end
