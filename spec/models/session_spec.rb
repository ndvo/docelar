require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'creation' do
    it 'creates a session for a user' do
      user = User.create!(email_address: 'test@example.com', password: 'password')
      session = described_class.create!(
        user: user,
        user_agent: 'Mozilla/5.0',
        ip_address: '127.0.0.1'
      )

      expect(session.user).to eq(user)
    end
  end
end
