require 'acceptance_helper'
require 'lockitron'

def lock(locked, id)
  lock = instance_double('Lockitron::Lock')
  allow(lock).to receive(:uuid).and_return(id)
  allow(lock).to receive(:locked?).and_return(locked)
  allow(lock).to receive(:unlocked?).and_return(!locked)
  allow(lock).to receive(:lock)
  allow(lock).to receive(:unlock)
  lock
end

resource 'Locks' do
  let!(:user) do
    user = FactoryGirl.create(:user)
    user.create_api_token
    user
  end

  let(:locked_lock) do
    {"uuid" => '1234567890abcdef', "locked" => true}
  end

  let(:unlocked_lock) do
    {"uuid" => '0987654321', "locked" => false}
  end

  get '/api/v1/locks' do
    before do
      lock1 = lock(true, '1234567890abcdef')
      lock2 = lock(false, '0987654321')
      lock_user = instance_double('Lockitron::User', :locks => [lock1, lock2])
      allow(Lockitron::User).to receive(:new).and_return(lock_user)
    end

    example 'Fetching all of the locks' do
      explanation 'It fetches all of the locks and returns them as an array of json objects'
      header 'Authorization', "Token token=\"#{user.api_token}\""
      do_request
      expect(response_status).to eq(200)
      parsed_body = JSON.parse(response_body)
      expect(parsed_body).to eq([locked_lock, unlocked_lock])
    end

    context 'without authorization' do
      it_should_behave_like 'an endpoint that requires authorization'
    end
  end

  get '/api/v1/locks/:id' do
    parameter :id, 'the id number (see lockitron api) for the desired lock'

    before do
      lock1 = lock(true, '1234567890abcdef')
      lock2 = lock(false, '0987654321')
      locks = [lock1, lock2]
      lock_user = instance_double('Lockitron::User', :locks => locks)
      allow(Lockitron::User).to receive(:new).and_return(lock_user)
    end

    example 'Fetching a single lock' do
      explanation 'It fetches a single lock given the lock\'s id number'
      header 'Authorization', "Token token=\"#{user.api_token}\""
      do_request(id: '1234567890abcdef')
      expect(response_status).to eq(200)
      parsed_body = JSON.parse(response_body)
      expect(parsed_body).to eq(locked_lock)
    end

    context 'without authorization' do
      it_should_behave_like 'an endpoint that requires authorization'
    end
  end

  put '/api/v1/locks/:id' do
    lock1 = nil
    lock2 = nil
    before do
      lock1 = lock(true, '1234567890abcdef')
      lock2 = lock(false, '0987654321')
      locks = [lock1, lock2]
      lock_user = instance_double('Lockitron::User', :locks => locks)
      allow(Lockitron::User).to receive(:new).and_return(lock_user)
    end

    parameter :id, 'the id number for the desired lock'
    parameter :lock, 'Indicates whether to lock (true) or unlock (false) the bulb'

    example 'locking a lock' do
      explanation 'It fetches a single lock given the lock\'s id number, and locks or unlocks it'
      header 'Authorization', "Token token=\"#{user.api_token}\""
      do_request(id: '0987654321', lock: true)
      expect(response_status).to eq(200)
      parsed_body = JSON.parse(response_body)
      expect(parsed_body).to eq({"uuid" => '0987654321', "locked" => true})
      expect(lock2).to have_received(:lock)
    end

    example 'unlocking a lock' do
      explanation 'It fetches a single lock given the lock\'s id number, and locks or unlocks it'
      header 'Authorization', "Token token=\"#{user.api_token}\""
      do_request(id: '1234567890abcdef', lock: false)
      expect(response_status).to eq(200)
      parsed_body = JSON.parse(response_body)
      expect(parsed_body).to eq({"uuid" => '1234567890abcdef', "locked" => false})

      expect(lock1).to have_received(:unlock)
    end

    context 'without authorization' do
      it_should_behave_like 'an endpoint that requires authorization'
    end
  end
end
