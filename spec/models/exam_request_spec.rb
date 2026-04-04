require 'rails_helper'

RSpec.describe ExamRequest, type: :model do
  let(:person) { create(:person, name: 'Maria') }
  let(:patient) { Patient.create!(individual: person) }

  describe 'associations' do
    it { should belong_to(:patient) }
    it { should belong_to(:medical_appointment).optional }
  end

  describe 'enums' do
    it 'allows valid statuses' do
      expect {
        create(:exam_request, patient: patient, status: :recommended)
        create(:exam_request, patient: patient, status: :requested)
        create(:exam_request, patient: patient, status: :scheduled)
        create(:exam_request, patient: patient, status: :completed)
        create(:exam_request, patient: patient, status: :cancelled)
      }.not_to raise_error
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:exam_name) }
    it { should validate_presence_of(:requested_date) }
  end
end
