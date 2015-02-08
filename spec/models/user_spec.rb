require 'rails_helper'

RSpec.describe User, :type => :model do
  let!(:user) do
    u = User.new(username: 'username', password: 'password', password_confirmation: 'password')
    u.save
    u
  end

  it 'should automatically create an api_token' do
    expect(user.api_token).to_not be_nil
  end


  describe 'username' do
    it 'should require usernames' do
      expect(user.valid?).to be_truthy
    end
    it 'should not allow nil usernames' do
      user.username = nil
      expect(user.valid?).to be_falsy
    end

    it 'should not allow duplicate usernames (case insensitive)' do
      other_user = user.dup
      other_user.username = user.username.upcase
      expect(other_user.valid?).to be_falsy
    end

  end

  describe 'password' do
    it 'should not allow nil passwords' do
      user.password = nil
      expect(user.valid?).to be_falsy
    end
  end
end
