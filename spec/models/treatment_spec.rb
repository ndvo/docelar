require 'rails_helper'

RSpec.describe Treatment, type: :model do
  describe 'associations' do
    it { should belong_to(:patient) }
    it { should have_many(:pharmacotherapies) }
  end

  describe 'enums' do
    it 'defines status enum' do
      expect(Treatment.statuses).to include('active', 'completed', 'paused', 'cancelled')
    end
    
    it 'defaults to active status' do
      treatment = create(:treatment)
      expect(treatment.status).to eq('active')
    end
  end

  describe 'scopes' do
    it 'has active_treatments scope' do
      active = create(:treatment, status: 'active')
      create(:treatment, status: 'completed')
      expect(Treatment.active_treatments).to include(active)
    end
  end

  describe 'nested attributes' do
    it 'accepts nested attributes for pharmacotherapies' do
      person = create(:person)
      patient = create(:patient, individual: person)
      medication = create(:medication)
      treatment = create(:treatment,
        patient: patient,
        pharmacotherapies_attributes: [{ medication_id: medication.id, dosage: '10mg', frequency: 'daily' }]
      )
      expect(treatment.pharmacotherapies.count).to eq 1
    end

    it 'allows destroying pharmacotherapies via nested attributes' do
      person = create(:person)
      patient = create(:patient, individual: person)
      medication = create(:medication)
      treatment = create(:treatment, patient: patient)
      pharmacotherapy = create(:pharmacotherapy, treatment: treatment, medication: medication)

      treatment.update!(pharmacotherapies_attributes: [{ id: pharmacotherapy.id, _destroy: true }])
      expect(treatment.pharmacotherapies.count).to eq 0
    end
  end
end
