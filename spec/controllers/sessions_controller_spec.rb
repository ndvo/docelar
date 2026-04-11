require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'redirects to root path on success' do
        User.create!(email_address: 'session-create@example.com', password: 'password123')
        post :create, params: { email_address: 'session-create@example.com', password: 'password123' }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid credentials' do
      it 'redirects to login with alert' do
        post :create, params: { email_address: 'test@example.com', password: 'wrongpassword' }
        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to be_present
      end
    end

    context 'with non-existent user' do
      it 'redirects to login with alert' do
        post :create, params: { email_address: 'nonexistent@example.com', password: 'password' }
        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { User.create!(email_address: 'logout@example.com', password: 'password') }
    let(:session) { Session.create!(user: user, user_agent: 'test', ip_address: '127.0.0.1') }

    before do
      cookies.signed[:session_id] = session.id
    end

    it 'redirects to login page' do
      delete :destroy
      expect(response).to redirect_to(new_session_path)
    end
  end
end
