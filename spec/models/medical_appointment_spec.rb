require 'rails_helper'

RSpec.describe MedicalAppointment, type: :model do
  let(:person) { create(:person, name: 'Maria') }
  let(:patient) { Patient.create!(individual: person) }

  describe 'associations' do
    it { should belong_to(:patient) }
    it { should have_many(:medical_exams) }
    it { should have_many(:exam_requests) }
  end

  describe 'enums' do
    it 'allows valid appointment types' do
      expect {
        create(:medical_appointment, patient: patient, appointment_type: :checkup)
        create(:medical_appointment, patient: patient, appointment_type: :specialist)
        create(:medical_appointment, patient: patient, appointment_type: :emergency)
      }.not_to raise_error
    end

    it 'allows valid statuses' do
      expect {
        create(:medical_appointment, patient: patient, status: :scheduled)
        create(:medical_appointment, patient: patient, status: :completed)
        create(:medical_appointment, patient: patient, status: :cancelled)
        create(:medical_appointment, patient: patient, status: :no_show)
      }.not_to raise_error
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:appointment_date) }
    it { should validate_presence_of(:appointment_type) }
  end

  describe 'scopes' do
    let!(:future_appointment) { create(:medical_appointment, patient: patient, appointment_date: 1.week.from_now, status: :scheduled) }
    let!(:past_appointment) { create(:medical_appointment, patient: patient, appointment_date: 1.week.ago, status: :completed) }
    let!(:upcoming) { create(:medical_appointment, patient: patient, appointment_date: 5.days.from_now, status: :scheduled) }

    describe '.upcoming' do
      it 'returns appointments from today onwards' do
        expect(MedicalAppointment.upcoming).to include(future_appointment, upcoming)
        expect(MedicalAppointment.upcoming).not_to include(past_appointment)
      end
    end

    describe '.past' do
      it 'returns appointments before today' do
        expect(MedicalAppointment.past).to include(past_appointment)
        expect(MedicalAppointment.past).not_to include(future_appointment, upcoming)
      end
    end

    describe '.pending_preparation' do
      it 'returns scheduled appointments in the future' do
        expect(MedicalAppointment.pending_preparation).to include(upcoming)
        expect(MedicalAppointment.pending_preparation).not_to include(past_appointment)
      end
    end
  end

  describe '#checklist_progress' do
    it 'returns 0 when checklist is empty' do
      appointment = create(:medical_appointment, patient: patient, checklist: [])
      expect(appointment.checklist_progress).to eq(0)
    end

    it 'returns 0 when checklist is nil' do
      appointment = create(:medical_appointment, patient: patient, checklist: nil)
      expect(appointment.checklist_progress).to eq(0)
    end

    it 'returns correct percentage for checked items' do
      appointment = create(:medical_appointment, patient: patient, checklist: [
        { 'text' => 'Item 1', 'checked' => true },
        { 'text' => 'Item 2', 'checked' => true },
        { 'text' => 'Item 3', 'checked' => false },
        { 'text' => 'Item 4', 'checked' => false }
      ])
      expect(appointment.checklist_progress).to eq(50)
    end
  end

  describe '#checklist_complete?' do
    it 'returns false when checklist is empty' do
      appointment = create(:medical_appointment, patient: patient, checklist: [])
      expect(appointment.checklist_complete?).to be false
    end

    it 'returns true when all items are checked' do
      appointment = create(:medical_appointment, patient: patient, checklist: [
        { 'text' => 'Item 1', 'checked' => true },
        { 'text' => 'Item 2', 'checked' => true }
      ])
      expect(appointment.checklist_complete?).to be true
    end

    it 'returns false when some items are unchecked' do
      appointment = create(:medical_appointment, patient: patient, checklist: [
        { 'text' => 'Item 1', 'checked' => true },
        { 'text' => 'Item 2', 'checked' => false }
      ])
      expect(appointment.checklist_complete?).to be false
    end
  end
end
