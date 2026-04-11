require 'rails_helper'

RSpec.describe PasswordsController, type: :controller do
  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

    context 'with existing user email' do
      it 'redirects to login with notice' do
        post :create, params: { email_address: 'test@example.com' }
        expect(response).to redirect_to(new_session_path)
        expect(flash[:notice]).to include('sent')
      end
    end

    context 'with non-existent email' do
      it 'still redirects with notice (security best practice)' do
        post :create, params: { email_address: 'nonexistent@example.com' }
        expect(response).to redirect_to(new_session_path)
        expect(flash[:notice]).to include('sent')
      end
    end
  end

  describe 'GET #edit' do
    context 'with invalid token' do
      it 'redirects to new password page' do
        get :edit, params: { token: 'invalid_token' }
        expect(response).to redirect_to(new_password_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PATCH #update' do
    context 'with invalid token' do
      it 'redirects to new password page' do
        patch :update, params: {
          token: 'invalid_token',
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }
        expect(response).to redirect_to(new_password_path)
      end
    end
  end
end
