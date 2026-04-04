require 'rails_helper'

RSpec.describe MedicalCondition, type: :model do
  let(:person) { create(:person, name: 'Maria') }
  let(:patient) { Patient.create!(individual: person) }

  describe 'associations' do
    it { should belong_to(:patient) }
    it { should have_many(:medical_condition_treatments) }
    it { should have_many(:treatments).through(:medical_condition_treatments) }
  end

  describe 'enums' do
    it 'allows valid statuses' do
      expect {
        create(:medical_condition, patient: patient, status: :active)
        create(:medical_condition, patient: patient, status: :resolved)
        create(:medical_condition, patient: patient, status: :chronic)
        create(:medical_condition, patient: patient, status: :under_treatment)
      }.not_to raise_error
    end

    it 'allows valid severity levels' do
      expect {
        create(:medical_condition, patient: patient, severity: :mild)
        create(:medical_condition, patient: patient, severity: :moderate)
        create(:medical_condition, patient: patient, severity: :severe)
      }.not_to raise_error
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:condition_name) }
    it { should validate_presence_of(:diagnosed_date) }
  end

  describe 'scopes' do
    let!(:active_condition) { create(:medical_condition, patient: patient, status: :active) }
    let!(:chronic_condition) { create(:medical_condition, patient: patient, status: :chronic) }
    let!(:resolved_condition) { create(:medical_condition, patient: patient, status: :resolved) }

    describe '.active_conditions' do
      it 'returns only active conditions' do
        expect(MedicalCondition.active_conditions).to include(active_condition)
        expect(MedicalCondition.active_conditions).not_to include(resolved_condition)
      end
    end

    describe '.chronic' do
      it 'returns only chronic conditions' do
        expect(MedicalCondition.chronic).to include(chronic_condition)
        expect(MedicalCondition.chronic).not_to include(active_condition)
      end
    end

    describe '.resolved' do
      it 'returns only resolved conditions' do
        expect(MedicalCondition.resolved).to include(resolved_condition)
        expect(MedicalCondition.resolved).not_to include(active_condition)
      end
    end
  end
end
