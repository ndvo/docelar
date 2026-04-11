require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { User.create!(email_address: 'admin@example.com', password: 'password') }

  before do
    session = user.sessions.create!(user_agent: 'test', ip_address: '127.0.0.1')
    cookies.signed[:session_id] = session.id
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new user' do
        expect {
          post :create, params: {
            user: { email_address: 'newuser@example.com', password: 'password123', password_confirmation: 'password123' }
          }
        }.to change(User, :count).by(1)
      end

      it 'redirects to root path' do
        post :create, params: {
          user: { email_address: 'newuser@example.com', password: 'password123', password_confirmation: 'password123' }
        }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a user with missing email' do
        expect {
          post :create, params: {
            user: { password: 'password123', password_confirmation: 'password123' }
          }
        }.not_to change(User, :count)
      end

      it 'renders new template with unprocessable entity' do
        post :create, params: {
          user: { password: 'password123', password_confirmation: 'password123' }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a user with mismatched passwords' do
        expect {
          post :create, params: {
            user: { email_address: 'newuser2@example.com', password: 'password123', password_confirmation: 'different' }
          }
        }.not_to change(User, :count)
      end

      it 'does not create a duplicate user' do
        existing = User.create!(email_address: 'unique@example.com', password: 'password', password_confirmation: 'password')

        expect {
          post :create, params: {
            user: { email_address: 'unique@example.com', password: 'password123', password_confirmation: 'password123' }
          }
        }.not_to change(User, :count)
      end
    end
  end
end
