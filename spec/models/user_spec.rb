require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:sessions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should have_secure_password }
  end

  describe 'normalizations' do
    describe 'email_address' do
      it 'strips whitespace and downcases email' do
        user = described_class.create!(
          email_address: '  TEST@EXAMPLE.COM  ',
          password: 'password123'
        )
        expect(user.email_address).to eq('test@example.com')
      end
    end
  end

  describe '#authenticate' do
    let(:user) { described_class.create!(email_address: 'test@example.com', password: 'password123') }

    it 'authenticates with correct password' do
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'returns false with incorrect password' do
      expect(user.authenticate('wrongpassword')).to be false
    end
  end
end
