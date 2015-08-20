require 'rails_helper'

include RegisterHelper

RSpec.describe RegisterController, type: :controller do
  describe 'going to signup screen' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'signing up' do
    context 'When a user with that username does not already exist' do
      it 'should allow the user to sign up, but is not able to change things' do
        post :create, {register: {username: 'blah', password: 'password', confirm_password: 'password'}}
        expect(response).to have_http_status(302)
        created_user = User.find_by(username: 'blah')
        expect(created_user).to_not be_nil
        expect(created_user.api_token).to be_nil
      end
    end

    context 'When a user with that username (case insensitive) already exists' do
      let!(:user) { FactoryGirl.create(:user, username: 'blah') }
      it 'should not allow the user to sign up' do
        post :create, {register: {username: 'BLAH', password: 'password', confirm_password: 'password'}}
        expect(User.find_by(username: 'BLAH').nil?).to be_truthy
      end
    end
  end
end
