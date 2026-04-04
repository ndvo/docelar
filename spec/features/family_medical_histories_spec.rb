require 'rails_helper'

RSpec.describe 'Family Medical Histories', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:person) { create(:person, name: 'Maria') }
  let(:patient) { Patient.create!(individual: person) }

  before { login_as(user) }

  describe 'family history CRUD' do
    scenario 'creates new family history' do
      visit new_patient_family_medical_history_path(patient)
      
      select 'Mother', from: 'family_medical_history[relation]'
      fill_in 'family_medical_history[condition_name]', with: 'Diabetes'
      fill_in 'family_medical_history[icd_code]', with: 'E11'
      fill_in 'family_medical_history[diagnosed_relative_date]', with: Date.today - 5.years
      fill_in 'family_medical_history[age_at_diagnosis]', with: 50
      
      click_button 'Salvar'
      
      expect(page).to have_content('Histórico familiar registrado com sucesso')
      expect(page).to have_content('Diabetes')
      expect(page).to have_content('E11')
    end

    scenario 'shows validation errors when creating with missing fields' do
      visit new_patient_family_medical_history_path(patient)
      
      click_button 'Salvar'
      
      expect(page).to have_content('erro')
      expect(page).to have_content('não pode ficar em branco')
    end

    scenario 'lists family history on patient page' do
      create(:family_medical_history, patient: patient, condition_name: 'Diabetes', relation: :mother)
      
      visit patient_path(patient)
      
      expect(page).to have_content('Histórico Familiar')
      expect(page).to have_content('Diabetes')
    end

    scenario 'shows family history details' do
      history = create(:family_medical_history, 
        patient: patient, 
        condition_name: 'Diabetes',
        relation: :mother,
        icd_code: 'E11',
        diagnosed_relative_date: Date.today - 5.years,
        age_at_diagnosis: 50)
      
      visit patient_family_medical_history_path(patient, history)
      
      expect(page).to have_content('Diabetes')
      expect(page).to have_content('E11')
      expect(page).to have_content('Mother')
      expect(page).to have_content('50')
    end

    scenario 'edits family history' do
      history = create(:family_medical_history, 
        patient: patient, 
        condition_name: 'Diabetes',
        relation: :mother,
        diagnosed_relative_date: Date.today - 5.years)
      
      visit edit_patient_family_medical_history_path(patient, history)
      select 'Father', from: 'family_medical_history[relation]'
      click_button 'Salvar'
      
      expect(page).to have_content('Histórico familiar atualizado com sucesso')
    end

    scenario 'deletes family history' do
      history = create(:family_medical_history, 
        patient: patient, 
        condition_name: 'Diabetes',
        relation: :mother,
        diagnosed_relative_date: Date.today - 5.years)
      
      visit patient_family_medical_histories_path(patient)
      
      expect {
        click_button 'Excluir', match: :first
      }.to change(FamilyMedicalHistory, :count).by(-1)
    end
  end
end
