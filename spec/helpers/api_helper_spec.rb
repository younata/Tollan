require 'rails_helper'

describe ApiHelper do
  describe 'int?' do
    it 'should return true if the given string is an integer' do
      expect(ApiHelper.int? "this is not an integer").to be_falsy
      expect(ApiHelper.int? '1337').to be_truthy
      expect(ApiHelper.int? '1337.0').to be_falsy
    end
  end

  describe 'as_int' do
    it 'should convert a string to an integer if it can' do
      expect(ApiHelper.as_int 'this is not an integer').to eq('this is not an integer')
      expect(ApiHelper.as_int '1337').to eq(1337)
      expect(ApiHelper.as_int '1337.0').to eq('1337.0')
    end
  end
end
