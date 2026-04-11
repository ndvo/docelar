require 'rails_helper'

RSpec.describe Person, type: :model do
  describe 'associations' do
    it { should have_many(:nationalities) }
    it { should have_many(:countries).through(:nationalities) }
    it { should have_one(:responsible) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'nested attributes' do
    it 'accepts nested nationalities attributes' do
      country = Country.create!(name: 'Brazil', status: 'public')
      person = described_class.create!(
        name: 'John Doe',
        nationalities_attributes: [{ country_id: country.id }]
      )

      expect(person.nationalities.count).to eq(1)
      expect(person.countries).to include(country)
    end

    it 'rejects blank nationality attributes' do
      person = described_class.create!(name: 'John Doe')
      person.nationalities_attributes = [{ country_id: '' }]
      person.save

      expect(person.nationalities.count).to eq(0)
    end
  end
end
