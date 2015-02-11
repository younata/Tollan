require 'rails_helper'
require 'Huey'

include SessionHelper

RSpec.describe BulbController, :type => :controller do

  context 'when logged in' do
    let!(:bulb) { instance_double('Huey::Bulb', :id => 1) }
    let!(:user) { FactoryGirl.create(:user) }

    before do
      allow(Huey::Bulb).to receive(:find).with(1).and_return(bulb)
      session[:user_id] = user.id
    end

    describe 'GET index' do
      before do
        allow(Huey::Bulb).to receive(:all).and_return([bulb])
      end

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

    describe 'PUT view' do
      before do
        allow(bulb).to receive(:on=)
        allow(bulb).to receive(:bri=)
        allow(bulb).to receive(:hue=)
        allow(bulb).to receive(:sat=)
        allow(bulb).to receive(:ct=)
        allow(bulb).to receive(:transitiontime=)
        allow(bulb).to receive(:rgb=)
        allow(bulb).to receive(:commit)

        allow(bulb).to receive(:on).and_return(true)
        allow(bulb).to receive(:bri).and_return(300)
        allow(bulb).to receive(:hue).and_return(5673)
        allow(bulb).to receive(:sat).and_return(135)
        allow(bulb).to receive(:ct).and_return(243)
        allow(bulb).to receive(:transitiontime).and_return(15)
        allow(bulb).to receive(:rgb).and_return('#123456')
      end

      it 'should successfully update the bulb' do
        bulb_hash = {on: 'false', brightness: '200', hue: '1024', saturation: '127', color_temp: '200', transition_time: '0', rgb: '#F30'}
        put :update, id: '1', bulb: bulb_hash
        # just testing  the happy path, see spec/helpers/bulb_helper_spec.rb for the more complete spec.

        expect(bulb).to have_received(:on=).with(false)
        expect(bulb).to have_received(:bri=).with(200)
        expect(bulb).to have_received(:hue=).with(1024)
        expect(bulb).to have_received(:sat=).with(127)
        expect(bulb).to have_received(:ct=).with(200)
        expect(bulb).to have_received(:transitiontime=).with(0)
        expect(bulb).to have_received(:rgb=).with("#F30")
        expect(bulb).to have_received(:commit)
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
