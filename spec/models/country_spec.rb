require 'rails_helper'

RSpec.describe Country, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_inclusion_of(:status).in_array(%w[public private archived]) }
  end

  describe 'persistence' do
    it 'can be created' do
      country = Country.create!(name: 'Brazil', status: 'public')
      expect(country).to be_persisted
    end
  end
end