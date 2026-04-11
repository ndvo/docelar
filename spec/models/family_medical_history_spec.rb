require 'rails_helper'

RSpec.describe FamilyMedicalHistory, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:patient) }
  end

  describe 'enums' do
    it 'defines relation enum values' do
      expect(described_class.relations.keys).to match_array(%w[mother father sibling grandparent other])
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:relation) }
    it { is_expected.to validate_presence_of(:condition_name) }
    it { is_expected.to validate_presence_of(:diagnosed_relative_date) }
  end

  describe 'scopes' do
    let(:patient) { create(:patient) }

    before do
      create(:family_medical_history, patient:, relation: :mother)
      create(:family_medical_history, patient:, relation: :father)
      create(:family_medical_history, patient:, relation: :mother)
    end

    it 'filters by relation' do
      expect(described_class.by_relation(:mother).count).to eq 2
      expect(described_class.by_relation(:father).count).to eq 1
    end
  end
end
