require 'rails_helper'

RSpec.describe 'Health Hub', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:person) { create(:person, name: 'Maria') }
  let(:patient) { Patient.create!(individual: person) }

  before { login_as(user) }

  describe 'health hub access' do
    scenario 'shows health hub from patient page' do
      visit patient_path(patient)
      
      click_link 'Resumo de Saúde'
      
      expect(page).to have_content('Resumo de Saúde')
    end

    scenario 'displays summary sections' do
      visit health_patient_path(patient)
      
      expect(page).to have_content('Próximas Consultas')
    end

    scenario 'shows upcoming appointments' do
      create(:medical_appointment, patient: patient, appointment_date: DateTime.now + 7.days, appointment_type: :checkup)
      
      visit health_patient_path(patient)
      
      expect(page).to have_content('Próximas Consultas')
      expect(page).to have_content('Checkup')
    end

    scenario 'shows active conditions' do
      create(:medical_condition, patient: patient, condition_name: 'Diabetes', status: :active)
      create(:medical_condition, patient: patient, condition_name: 'Hipertensão', status: :chronic)
      
      visit health_patient_path(patient)
      
      expect(page).to have_content('Diabetes')
      expect(page).to have_content('Hipertensão')
    end

    scenario 'shows active treatments' do
      treatment = create(:treatment, patient: patient, name: 'Diabetes Treatment', status: :active)
      create(:pharmacotherapy, treatment: treatment, medication: create(:medication, name: 'Metformina'))
      
      visit health_patient_path(patient)
      
      expect(page).to have_content('Tratamentos Ativos')
      expect(page).to have_content('Metformina')
    end

    scenario 'shows recent exams' do
      create(:medical_exam, patient: patient, exam_date: Date.today - 7.days, exam_type: :blood_test, name: 'Hemograma')
      
      visit health_patient_path(patient)
      
      expect(page).to have_content('Exames Realizados')
      expect(page).to have_content('Hemograma')
    end

    scenario 'shows quick actions section' do
      visit health_patient_path(patient)
      
      expect(page).to have_content('Ações Rápidas')
    end

    scenario 'shows tab navigation' do
      visit health_patient_path(patient)
      
      expect(page).to have_content('Consultas')
    end
  end
end
