require 'rails_helper'

RSpec.describe GroupController, :type => :controller do

  describe "GET index" do
    before (:each) do
      allow(Huey::Group).to receive(:all).and_return([])
    end
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET create" do
    it "returns http success" do
      get :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET update" do
    it "returns http success" do
      get :update
      expect(response).to have_http_status(:success)
    end
  end

end