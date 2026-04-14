require 'rails_helper'

RSpec.describe TaggedsController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before do
    session = user.sessions.create!(user_agent: 'test', ip_address: '127.0.0.1')
    cookies.signed[:session_id] = session.id
  end

  describe 'controller exists' do
    it 'can be instantiated' do
      expect { TaggedsController.new }.not_to raise_error
    end
  end
end