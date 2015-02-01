require 'rails_helper'

RSpec.describe HueController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns the lights as a json" do
    end
  end

  describe "PUT update" do
    it "returns http failure" do
      get :update
      expect(response).to have_http_status(:success)
    end
  end

end
