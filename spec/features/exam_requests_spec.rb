require 'rails_helper'

RSpec.describe 'Exam Requests', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:person) { create(:person, name: 'Maria') }
  let(:patient) { Patient.create!(individual: person) }

  before { login_as(user) }

  describe 'exam request CRUD' do
    scenario 'creates new exam request' do
      visit new_patient_exam_request_path(patient)
      
      fill_in 'exam_request[exam_name]', with: 'Ressonância Magnética'
      fill_in 'exam_request[requested_date]', with: Date.today
      
      click_button 'Salvar'
      
      expect(page).to have_content('Solicitação de exame registrada com sucesso')
      expect(page).to have_content('Ressonância Magnética')
    end

    scenario 'shows validation errors when creating with missing fields' do
      visit new_patient_exam_request_path(patient)
      
      click_button 'Salvar'
      
      expect(page).to have_content('erro')
      expect(page).to have_content('não pode ficar em branco')
    end

    scenario 'lists exam requests on patient page' do
      create(:exam_request, patient: patient, exam_name: 'Ressonância Magnética', requested_date: Date.today)
      
      visit patient_path(patient)
      
      expect(page).to have_content('Solicitações de Exames')
      expect(page).to have_content('Ressonância Magnética')
    end

    scenario 'shows exam request details' do
      request = create(:exam_request, 
        patient: patient, 
        exam_name: 'Ressonância Magnética',
        requested_date: Date.today,
        scheduled_date: Date.today + 14.days,
        notes: 'Para verificar articulação')
      
      visit patient_exam_request_path(patient, request)
      
      expect(page).to have_content('Ressonância Magnética')
      expect(page).to have_content('Para verificar articulação')
    end

    scenario 'edits exam request' do
      request = create(:exam_request, 
        patient: patient, 
        exam_name: 'Ressonância Magnética',
        requested_date: Date.today)
      
      visit edit_patient_exam_request_path(patient, request)
      select 'Scheduled', from: 'exam_request[status]'
      click_button 'Salvar'
      
      expect(page).to have_content('Solicitação atualizada com sucesso')
    end

    scenario 'deletes exam request' do
      request = create(:exam_request, 
        patient: patient, 
        exam_name: 'Ressonância Magnética',
        requested_date: Date.today)
      
      visit patient_exam_requests_path(patient)
      
      expect {
        click_button 'Excluir', match: :first
      }.to change(ExamRequest, :count).by(-1)
    end
  end
end
