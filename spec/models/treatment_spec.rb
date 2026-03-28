require 'rails_helper'

RSpec.describe Treatment, type: :model do
  describe 'associations' do
    it { should belong_to(:patient) }
    it { should have_many(:pharmacotherapies) }
  end

  describe 'nested attributes' do
    it 'accepts nested attributes for pharmacotherapies' do
      person = Person.create!(name: 'Test')
      patient = Patient.create!(individual: person, individual_type: 'Person')
      medication = Medication.create!(name: 'Aspirin')
      treatment = Treatment.create!(
        patient: patient,
        pharmacotherapies_attributes: [{ medication_id: medication.id }]
      )
      expect(treatment.pharmacotherapies.count).to eq 1
    end

    it 'allows destroying pharmacotherapies via nested attributes' do
      person = Person.create!(name: 'Test')
      patient = Patient.create!(individual: person, individual_type: 'Person')
      medication = Medication.create!(name: 'Aspirin')
      treatment = Treatment.create!(patient: patient)
      pharmacotherapy = Pharmacotherapy.create!(treatment: treatment, medication: medication)

      treatment.update!(pharmacotherapies_attributes: [{ id: pharmacotherapy.id, _destroy: true }])
      expect(treatment.pharmacotherapies.count).to eq 0
    end
  end
end
