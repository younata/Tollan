require 'rails_helper'
require 'huey'

RSpec.describe BulbHelper, :type => :helper do
  let!(:bulb) { instance_double('Huey::Bulb', :id => 1) }

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
    allow(bulb).to receive(:transitiontime).and_return(10)
    allow(bulb).to receive(:rgb).and_return('#123456')


    allow(Huey::Bulb).to receive(:find).with(1).and_return(bulb)
  end

  it 'should update the bulb' do
    update_bulb('1', nil, 'false', '200', '1024', '127', '200', '0', '#F30')
    expect(bulb).to have_received(:on=).with(false)
    expect(bulb).to have_received(:bri=).with(200)
    expect(bulb).to have_received(:hue=).with(1024)
    expect(bulb).to have_received(:sat=).with(127)
    expect(bulb).to have_received(:ct=).with(200)
    expect(bulb).to have_received(:transitiontime=).with(0)
    expect(bulb).to have_received(:rgb=).with("#F30")
    expect(bulb).to have_received(:commit)
  end

  describe 'updating boolean values' do
    it 'should allow 0 values for booleans to stand in for false' do
      update_bulb('1', nil, '0', nil, nil, nil, nil, nil, nil)
      expect(bulb).to have_received(:on=).with(false)
      expect(bulb).to have_received(:commit)
    end

    it 'should allow 1 values for booleans to stand in for true' do
      allow(bulb).to receive(:on).and_return(false)
      update_bulb('1', nil, '1', nil, nil, nil, nil, nil, nil)
      expect(bulb).to have_received(:on=).with(true)
      expect(bulb).to have_received(:commit)
    end
  end

  it 'should update only values that aren\'t nil' do
    update_bulb('1', nil, nil, nil, nil, nil, nil, '0', nil)
    expect(bulb).to_not have_received(:on=)
    expect(bulb).to_not have_received(:bri=)
    expect(bulb).to_not have_received(:hue=)
    expect(bulb).to_not have_received(:sat=)
    expect(bulb).to_not have_received(:ct=)
    expect(bulb).to_not have_received(:rgb=)
    expect(bulb).to have_received(:transitiontime=).with(0)
    expect(bulb).to have_received(:commit)
  end

  it 'should not update bulb values that are not nil, but are equal to the existing value' do
    update_bulb('1', nil, nil, '300', nil, nil, nil, nil, nil)
    expect(bulb).to_not have_received(:on=)
    expect(bulb).to_not have_received(:bri=)
    expect(bulb).to_not have_received(:hue=)
    expect(bulb).to_not have_received(:sat=)
    expect(bulb).to_not have_received(:ct=)
    expect(bulb).to_not have_received(:transitiontime=)
    expect(bulb).to_not have_received(:rgb=)
    expect(bulb).to_not have_received(:commit)
  end

  it 'should not update if all values are nil' do
    update_bulb('1', nil, nil, nil, nil, nil, nil, nil, nil)
    expect(bulb).to_not have_received(:on=)
    expect(bulb).to_not have_received(:bri=)
    expect(bulb).to_not have_received(:hue=)
    expect(bulb).to_not have_received(:sat=)
    expect(bulb).to_not have_received(:ct=)
    expect(bulb).to_not have_received(:transitiontime=)
    expect(bulb).to_not have_received(:rgb=)
    expect(bulb).to_not have_received(:commit)
  end
end
