require 'rails_helper'

RSpec.describe 'Medical Appointments', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:person) { create(:person, name: 'Maria') }
  let(:patient) { Patient.create!(individual: person) }

  before { login_as(user) }

  describe 'appointment CRUD' do
    scenario 'creates new appointment' do
      visit new_patient_medical_appointment_path(patient)
      
      fill_in 'medical_appointment[appointment_date]', with: DateTime.now + 7.days
      select 'Checkup', from: 'medical_appointment[appointment_type]'
      fill_in 'medical_appointment[specialty]', with: 'Cardiologia'
      fill_in 'medical_appointment[professional_name]', with: 'Dr. João'
      fill_in 'medical_appointment[location]', with: 'Hospital Central'
      
      click_button 'Salvar'
      
      expect(page).to have_content('Consulta agendada com sucesso')
      expect(page).to have_content('Checkup')
      expect(page).to have_content('Cardiologia')
    end

    scenario 'shows validation errors when creating with missing fields' do
      visit new_patient_medical_appointment_path(patient)
      
      click_button 'Salvar'
      
      expect(page).to have_content('erro')
      expect(page).to have_content('não pode ficar em branco')
    end

    scenario 'lists appointments on patient page' do
      create(:medical_appointment, patient: patient, appointment_date: DateTime.now + 7.days, appointment_type: :checkup)
      
      visit patient_path(patient)
      
      expect(page).to have_content('Consultas')
      expect(page).to have_content('Checkup')
    end

    scenario 'shows appointment details' do
      appointment = create(:medical_appointment, 
        patient: patient, 
        appointment_date: DateTime.now + 7.days,
        appointment_type: :specialist,
        specialty: 'Cardiologia',
        professional_name: 'Dr. João',
        location: 'Hospital Central',
        reason: 'Checkup anual')
      
      visit patient_medical_appointment_path(patient, appointment)
      
      expect(page).to have_content('Specialist')
      expect(page).to have_content('Cardiologia')
      expect(page).to have_content('Dr. João')
      expect(page).to have_content('Hospital Central')
    end

    scenario 'edits appointment' do
      appointment = create(:medical_appointment, 
        patient: patient, 
        appointment_date: DateTime.now + 7.days,
        appointment_type: :checkup)
      
      visit edit_patient_medical_appointment_path(patient, appointment)
      select 'Specialist', from: 'medical_appointment[appointment_type]'
      click_button 'Salvar'
      
      expect(page).to have_content('Consulta atualizada com sucesso')
    end

    scenario 'deletes appointment' do
      appointment = create(:medical_appointment, 
        patient: patient, 
        appointment_date: DateTime.now + 7.days,
        appointment_type: :checkup)
      
      visit patient_medical_appointments_path(patient)
      
      expect {
        click_button 'Excluir', match: :first
      }.to change(MedicalAppointment, :count).by(-1)
    end

    scenario 'cancels appointment' do
      appointment = create(:medical_appointment, 
        patient: patient, 
        appointment_date: DateTime.now + 7.days,
        appointment_type: :checkup,
        status: :scheduled)
      
      visit edit_patient_medical_appointment_path(patient, appointment)
      select 'Cancelled', from: 'medical_appointment[status]'
      click_button 'Salvar'
      
      expect(page).to have_content('Cancelled')
    end
  end

  describe 'appointment preparation' do
    scenario 'prepares appointment with checklist' do
      appointment = create(:medical_appointment, 
        patient: patient, 
        appointment_date: DateTime.now + 7.days,
        appointment_type: :checkup)
      
      visit prepare_patient_medical_appointment_path(patient, appointment)
      
      fill_in 'medical_appointment[preparation_notes]', with: 'Dor de cabeça'
      fill_in 'medical_appointment[questions]', with: 'Qual o diagnóstico?'
      
      click_button 'Salvar Preparação'
      
      expect(page).to have_content('Checklist atualizado')
      expect(page).to have_content('Dor de cabeça')
    end

    scenario 'shows preparation summary on appointment details' do
      appointment = create(:medical_appointment, 
        patient: patient, 
        appointment_date: DateTime.now + 7.days,
        appointment_type: :checkup,
        status: :scheduled,
        preparation_notes: 'Dor de cabeça',
        checklist: [{ 'text' => 'Levar documentos', 'checked' => true }])
      
      visit patient_medical_appointment_path(patient, appointment)
      
      expect(page).to have_content('Preparar Consulta')
      expect(page).to have_content('100% completo')
    end

    scenario 'completes follow-up after appointment' do
      appointment = create(:medical_appointment, 
        patient: patient, 
        appointment_date: DateTime.now - 1.day,
        appointment_type: :checkup,
        status: :completed)
      
      visit follow_up_patient_medical_appointment_path(patient, appointment)
      
      fill_in 'medical_appointment[post_appointment_notes]', with: 'Diagnostico: Hipertensao'
      check 'medical_appointment_follow_up_required'
      fill_in 'medical_appointment[follow_up_date]', with: Date.today + 30.days
      
      click_button 'Salvar'
      
      expect(page).to have_content('Consulta atualizada com sucesso')
      expect(page).to have_content('Follow-up')
    end
  end
end
