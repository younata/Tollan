require 'acceptance_helper'
require 'huey'

resource 'Groups' do
  let!(:user) { FactoryGirl.create(:user) }

  get '/api/v1/bulbs/groups' do
    before do
      allow(Huey::Group).to receive(:all).and_return([{something: 'testing'}])
    end

    example 'Fetching all of the groups' do
      header 'Authorization', "Token token=\"#{user.api_token}\""
      do_request
      expect(response_status).to eq(200)
      parsed_body = JSON.parse(response_body)
      expect(parsed_body).to eq([{"something"=>"testing"}])
    end

    context 'without authorization' do
      it_should_behave_like 'an endpoint that requires authorization'
    end
  end

  get '/api/v1/bulbs/groups/:id' do
    before do
      allow(Huey::Group).to receive(:find).with(1).and_return({something: 'testing'})
      allow(Huey::Group).to receive(:find).with('main').and_return({something: 'testing'})
    end

    parameter :id, "The name (string) or id number (integer) for a given group"

    example 'Fetching a single group by id number' do
      header 'Authorization', "Token token=\"#{user.api_token}\""
      do_request(id: 1)
      expect(response_status).to eq(200)
      parsed_body = JSON.parse(response_body)
      expect(parsed_body).to eq({"something"=>"testing"})
    end

    example 'Fetching a single group by name' do
      header 'Authorization', "Token token=\"#{user.api_token}\""
      do_request(id: 'main')
      expect(response_status).to eq(200)
      parsed_body = JSON.parse(response_body)
      expect(parsed_body).to eq({"something"=>"testing"})
    end

    context 'without authorization' do
      it_should_behave_like 'an endpoint that requires authorization'
    end
  end

  # Todo: create/update/delete groups.
end

#RSpec.describe GroupController, :type => :controller do
#
#  describe "GET index" do
#    before (:each) do
#      allow(Huey::Group).to receive(:all).and_return([])
#    end
#    it "returns http success" do
#      get :index
#      expect(response).to have_http_status(:success)
#    end
#  end
#
#  describe "GET show" do
#    it "returns http success" do
#      get :show
#      expect(response).to have_http_status(:success)
#    end
#  end
#
#  describe "GET create" do
#    it "returns http success" do
#      get :create
#      expect(response).to have_http_status(:success)
#    end
#  end
#
#  describe "GET update" do
#    it "returns http success" do
#      get :update
#      expect(response).to have_http_status(:success)
#    end
#  end
#
#end
