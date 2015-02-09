require 'rails_helper'
require 'Huey'

RSpec.describe BulbController, :type => :controller do
  let!(:bulb) { instance_double('Huey::Bulb', :id => 1) }

  before do
    allow(Huey::Bulb).to receive(:find).with(1).and_return(bulb)
    allow(Huey::Bulb).to receive(:all).and_return([bulb])
  end

  describe "GET index" do
    it "returns http success" do
      controller.bulbs = nil
      get :index
      expect(response).to have_http_status(:success)
      expect(controller.bulbs).to_not be_nil
    end
  end

  describe "GET view" do
    it "returns http success" do
      controller.bulb = nil
      get :view, id: '1'
      expect(response).to have_http_status(:success)
      expect(controller.bulb).to_not be_nil
    end
  end
end
