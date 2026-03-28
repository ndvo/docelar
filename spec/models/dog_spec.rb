require 'rails_helper'

RSpec.describe Dog, type: :model do
  describe '#sync_patient' do
    it 'creates a patient when dog is saved' do
      dog = described_class.create!(name: 'Buddy')
      patient = Patient.find_by(individual_id: dog.id, individual_type: 'Dog')
      expect(patient).to be_present
      expect(patient.individual).to eq dog
    end

    it 'does not create duplicate patients on multiple saves' do
      dog = described_class.create!(name: 'Buddy')
      dog.update!(name: 'Max')
      expect(Patient.where(individual_id: dog.id, individual_type: 'Dog').count).to eq 1
    end

    it 'finds existing patient on update' do
      dog = described_class.create!(name: 'Buddy')
      patient = Patient.find_by(individual_id: dog.id, individual_type: 'Dog')
      dog.update!(name: 'Max')
      expect(Patient.find_by(individual_id: dog.id, individual_type: 'Dog')).to eq patient
    end
  end
end
