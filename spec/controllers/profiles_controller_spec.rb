require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password123') }

  before do
    session = user.sessions.create!(user_agent: 'test', ip_address: '127.0.0.1')
    cookies.signed[:session_id] = session.id
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show
      expect(response).to be_successful
    end
  end

  describe 'PATCH #password' do
    context 'with correct current password' do
      it 'updates the password' do
        patch :password, params: {
          user: {
            current_password: 'password123',
            password: 'newpassword456',
            password_confirmation: 'newpassword456'
          }
        }
        user.reload
        expect(user.authenticate('newpassword456')).to eq(user)
      end

      it 'redirects to profile with notice' do
        patch :password, params: {
          user: {
            current_password: 'password123',
            password: 'newpassword456',
            password_confirmation: 'newpassword456'
          }
        }
        expect(response).to redirect_to(profile_path)
        expect(flash[:notice]).to be_present
      end
    end

    context 'with incorrect current password' do
      it 'does not update the password' do
        original_digest = user.password_digest
        patch :password, params: {
          user: {
            current_password: 'wrongpassword',
            password: 'newpassword456',
            password_confirmation: 'newpassword456'
          }
        }
        user.reload
        expect(user.password_digest).to eq(original_digest)
      end

      it 'renders show with error' do
        patch :password, params: {
          user: {
            current_password: 'wrongpassword',
            password: 'newpassword456',
            password_confirmation: 'newpassword456'
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:alert]).to be_present
      end
    end

    context 'with mismatched passwords' do
      it 'does not update the password' do
        original_digest = user.password_digest
        patch :password, params: {
          user: {
            current_password: 'password123',
            password: 'newpassword456',
            password_confirmation: 'different'
          }
        }
        user.reload
        expect(user.password_digest).to eq(original_digest)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with correct password' do
      it 'deletes the user account' do
        expect {
          delete :destroy, params: { user: { current_password: 'password123' } }
        }.to change(User, :count).by(-1)
      end

      it 'redirects to root path' do
        delete :destroy, params: { user: { current_password: 'password123' } }
        expect(response).to redirect_to(root_path)
      end

      it 'clears all sessions' do
        expect {
          delete :destroy, params: { user: { current_password: 'password123' } }
        }.to change(Session, :count).by(-1)
      end
    end

    context 'with incorrect password' do
      it 'does not delete the user' do
        expect {
          delete :destroy, params: { user: { current_password: 'wrongpassword' } }
        }.not_to change(User, :count)
      end

      it 'redirects to profile with alert' do
        delete :destroy, params: { user: { current_password: 'wrongpassword' } }
        expect(response).to redirect_to(profile_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
