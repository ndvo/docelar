require 'rails_helper'

RSpec.describe MedicalExam, type: :model do
  let(:person) { create(:person, name: 'Maria') }
  let(:patient) { Patient.create!(individual: person) }

  describe 'associations' do
    it { should belong_to(:patient) }
    it { should belong_to(:medical_appointment).optional }
  end

  describe 'enums' do
    it 'allows valid exam types' do
      expect {
        create(:medical_exam, patient: patient, exam_type: :blood_test)
        create(:medical_exam, patient: patient, exam_type: :urine_test)
        create(:medical_exam, patient: patient, exam_type: :imaging)
      }.not_to raise_error
    end

    it 'allows valid statuses' do
      expect {
        create(:medical_exam, patient: patient, status: :scheduled)
        create(:medical_exam, patient: patient, status: :completed)
        create(:medical_exam, patient: patient, status: :results_received)
      }.not_to raise_error
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:exam_date) }
    it { should validate_presence_of(:exam_type) }
  end
end
