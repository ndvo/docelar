require 'rails_helper'

RSpec.describe Nationality, type: :model do
  describe 'associations' do
    it { should belong_to(:person) }
    it { should belong_to(:country) }
  end

  describe 'validations' do
    it { should validate_presence_of(:person) }
    it { should validate_presence_of(:country) }
  end

  describe 'enum' do
    it 'has the correct how values' do
      expect(described_class.hows.keys).to match_array(%w[jusSanguini jusSoli naturalization])
    end
  end
end
