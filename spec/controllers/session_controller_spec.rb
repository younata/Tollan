require 'rails_helper'

include SessionHelper

RSpec.describe SessionController, :type => :controller do

  describe 'GET new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'logging in' do
    context 'When the user enters a valid username/password combination' do
      let!(:user) { FactoryGirl.create(:user, password: 'a_password') }
      it 'should log in' do
        post :create, {session: {username: user.username, password: 'a_password'}}
        expect(logged_in?).to be_truthy
      end
    end

    context 'When the user enters an invalid username/password combination' do
      it 'should log in' do
        post :create, {session: {username: 'not a username', password: 'not a password'}}
        expect(logged_in?).to be_falsy
      end
    end
  end

  describe 'logging out' do
    let!(:user) { FactoryGirl.create(:user) }

    before do
      session[:user_id] = user.id
      delete :destroy
    end

    it 'should log the user out' do
      expect(logged_in?).to be_falsy
    end
  end
end
