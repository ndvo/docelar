require 'rails_helper'

RSpec.describe Patient, type: :model do
  describe 'associations' do
    it { should belong_to(:individual) }
  end

  describe 'validations' do
    it 'validates uniqueness of individual_id scoped to individual_type' do
      person = Person.create!(name: 'Test')
      described_class.create!(individual: person, individual_type: 'Person')
      new_patient = described_class.new(individual: person, individual_type: 'Person')
      expect(new_patient).not_to be_valid
    end
  end
end
