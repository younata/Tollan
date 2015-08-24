require 'rails_helper'

def lock(locked, id)
  lock = instance_double('Lockitron::Lock')
  allow(lock).to receive(:uuid).and_return(id)
  allow(lock).to receive(:locked?).and_return(locked)
  allow(lock).to receive(:unlocked?).and_return(!locked)
  allow(lock).to receive(:lock)
  allow(lock).to receive(:unlock)
  allow(lock).to receive(:name).and_return("name")
  lock
end

RSpec.describe LockController, type: :controller do
  context 'when logged in' do
    let!(:user) { FactoryGirl.create(:user) }

    before do
      session[:user_id] = user.id
    end

    describe 'with a valid api token' do
      lock1 = nil
      lock2 = nil
      before do
        user.create_api_token
        lock1 = lock(true, '1234567890abcdef')
        lock2 = lock(false, '0987654321')
        lock_user = instance_double('Lockitron::User', :locks => [lock1, lock2])
        allow(Lockitron::User).to receive(:new).and_return(lock_user)
      end

      describe 'GET #index' do
        it 'returns http success' do
          get :index
          expect(response).to have_http_status(:success)
        end
      end

      describe 'viewing a single lock' do
        it 'returns http success' do
          get :view, id: '1234567890abcdef'
          expect(response).to have_http_status(:success)
        end
      end

      describe 'updating a lock' do
        describe 'locking it' do
          it 'returns http success' do
            put :update, id: '1234567890abcdef', lock: true
            expect(lock1).to have_received(:lock)
            expect(response).to redirect_to("/locks/1234567890abcdef")
          end
        end

        describe 'unlocking it' do
          it 'returns http success' do
            put :update, id: '0987654321', lock: false
            expect(lock2).to have_received(:unlock)
            expect(response).to redirect_to("/locks/0987654321")
          end
        end
      end
    end

    context 'without an api token' do
      describe 'GET index' do
        it 'should redirect the user to the main page' do
          get :index
          expect(response).to redirect_to '/'
        end
      end

      describe 'GET view' do
        it 'should redirect the user to the main page' do
          get :view, id: '1'
          expect(response).to redirect_to '/'
        end
      end
      describe 'PUT view' do
        it 'should redirect the user to the main page' do
          put :update, id: '1'
          expect(response).to redirect_to '/'
        end
      end
    end
  end

  context 'When not logged in' do
    describe 'GET index' do
      it 'should redirect the user to the login page' do
        get :index
        expect(response).to redirect_to '/login'
      end
    end

    describe 'GET view' do
      it 'should redirect the user to the login page' do
        get :view, id: '1'
        expect(response).to redirect_to '/login'
      end
    end
    describe 'PUT view' do
      it 'should redirect the user to the login page' do
        put :update, id: '1'
        expect(response).to redirect_to '/login'
      end
    end
  end
end
