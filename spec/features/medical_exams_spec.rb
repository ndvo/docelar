require 'rails_helper'

RSpec.describe 'Medical Exams', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:person) { create(:person, name: 'Maria') }
  let(:patient) { Patient.create!(individual: person) }

  before { login_as(user) }

  describe 'exam CRUD' do
    scenario 'creates new exam' do
      visit new_patient_medical_exam_path(patient)
      
      fill_in 'medical_exam[exam_date]', with: Date.new(2025, 6, 15)
      select 'Blood test', from: 'medical_exam[exam_type]'
      fill_in 'medical_exam[name]', with: 'Hemograma Completo'
      fill_in 'medical_exam[laboratory]', with: 'Lab São Paulo'
      
      click_button 'Salvar'
      
      expect(page).to have_content('Exame registrado com sucesso')
      expect(page).to have_content('Blood test')
      expect(page).to have_content('Hemograma Completo')
    end

    scenario 'lists exams on patient page' do
      create(:medical_exam, patient: patient, exam_date: Date.new(2025, 6, 15), exam_type: :blood_test)
      
      visit patient_path(patient)
      
      expect(page).to have_content('Exames')
      expect(page).to have_content('Blood test')
    end

    scenario 'shows exam details' do
      exam = create(:medical_exam, 
        patient: patient, 
        exam_date: Date.new(2025, 6, 15),
        exam_type: :blood_test,
        name: 'Hemograma Completo',
        laboratory: 'Lab São Paulo',
        results_summary: 'Tudo normal')
      
      visit patient_medical_exam_path(patient, exam)
      
      expect(page).to have_content('Blood test')
      expect(page).to have_content('Hemograma Completo')
      expect(page).to have_content('Lab São Paulo')
      expect(page).to have_content('Tudo normal')
    end

    scenario 'edits exam' do
      exam = create(:medical_exam, 
        patient: patient, 
        exam_date: Date.new(2025, 6, 15),
        exam_type: :blood_test)
      
      visit edit_patient_medical_exam_path(patient, exam)
      select 'Urine test', from: 'medical_exam[exam_type]'
      click_button 'Salvar'
      
      expect(page).to have_content('Exame atualizado com sucesso')
    end

    scenario 'deletes exam' do
      exam = create(:medical_exam, 
        patient: patient, 
        exam_date: Date.new(2025, 6, 15),
        exam_type: :blood_test)
      
      visit patient_medical_exams_path(patient)
      
      expect {
        click_button 'Excluir', match: :first
      }.to change(MedicalExam, :count).by(-1)
    end
  end
end
