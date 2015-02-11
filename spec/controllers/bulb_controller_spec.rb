require 'rails_helper'
require 'Huey'

include SessionHelper

RSpec.describe BulbController, :type => :controller do

  context 'when logged in' do
    let!(:bulb) { instance_double('Huey::Bulb', :id => 1) }
    let!(:user) { FactoryGirl.create(:user) }

    before do
      allow(Huey::Bulb).to receive(:find).with(1).and_return(bulb)
      allow(Huey::Bulb).to receive(:all).and_return([bulb])
      session[:user_id] = user.id
    end

    describe 'GET index' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET view' do
      it 'returns http success' do
        get :view, id: '1'
        expect(response).to have_http_status(:success)
      end
    end
  end

  context 'when not logged in' do
    describe 'GET index' do
      it 'should redirect the user to the legin page' do
        get :index
        expect(response).to redirect_to '/login'
      end
    end

    describe 'GET view' do
      it 'should redirect the user to the legin page' do
        get :view, id: '1'
        expect(response).to redirect_to '/login'
      end
    end
  end
end
