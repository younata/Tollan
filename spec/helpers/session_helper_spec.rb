require 'rails_helper'

RSpec.describe SessionHelper, :type => :helper do
  let!(:user) { FactoryGirl.create(:user) }

  context 'When logged in' do
    before do
      log_in(user)
    end

    it 'should allow the user to log in' do
      expect(session[:user_id]).to eq(user.id)
    end

    it 'should get the current user' do
      expect(current_user).to eq(user)
    end

    it 'should identify the user as logged in' do
      expect(logged_in?).to be_truthy
    end

    it 'should allow the user to log out' do
      expect(logged_in?).to be_truthy
      log_out
      expect(logged_in?).to be_falsy
      expect(current_user).to be_nil
    end
  end

  context 'When logged out' do
    it 'should have no session for the user' do
      expect(session[:user_id]).to be_nil
    end
    it 'should return nil for the current user' do
      expect(current_user).to be_nil
    end

    it 'should identify the user as logged out' do
      expect(logged_in?).to be_falsy
    end
  end
end
