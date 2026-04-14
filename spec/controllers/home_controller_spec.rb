require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before do
    session = user.sessions.create!(user_agent: 'test', ip_address: '127.0.0.1')
    cookies.signed[:session_id] = session.id
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end
end