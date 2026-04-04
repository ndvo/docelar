require 'rails_helper'

RSpec.describe 'Medical Conditions', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:person) { create(:person, name: 'Maria') }
  let(:patient) { Patient.create!(individual: person) }

  before { login_as(user) }

  describe 'condition CRUD' do
    scenario 'creates new condition' do
      visit new_patient_medical_condition_path(patient)
      
      fill_in 'medical_condition[condition_name]', with: 'Hipertensão'
      fill_in 'medical_condition[icd_code]', with: 'I10'
      fill_in 'medical_condition[diagnosed_date]', with: Date.today
      select 'Active', from: 'medical_condition[status]'
      
      click_button 'Salvar'
      
      expect(page).to have_content('Condição registrada com sucesso')
      expect(page).to have_content('Hipertensão')
      expect(page).to have_content('I10')
    end

    scenario 'shows validation errors when creating with missing fields' do
      visit new_patient_medical_condition_path(patient)
      
      click_button 'Salvar'
      
      expect(page).to have_content('erro')
      expect(page).to have_content('não pode ficar em branco')
    end

    scenario 'lists conditions on patient page' do
      create(:medical_condition, patient: patient, condition_name: 'Diabetes', diagnosed_date: Date.today)
      
      visit patient_path(patient)
      
      expect(page).to have_content('Condições de Saúde')
      expect(page).to have_content('Diabetes')
    end

    scenario 'shows condition details' do
      condition = create(:medical_condition, 
        patient: patient, 
        condition_name: 'Hipertensão',
        icd_code: 'I10',
        diagnosed_date: Date.today,
        severity: :moderate,
        status: :chronic)
      
      visit patient_medical_condition_path(patient, condition)
      
      expect(page).to have_content('Hipertensão')
      expect(page).to have_content('I10')
      expect(page).to have_content('Moderate')
      expect(page).to have_content('Chronic')
    end

    scenario 'edits condition' do
      condition = create(:medical_condition, 
        patient: patient, 
        condition_name: 'Hipertensão',
        diagnosed_date: Date.today)
      
      visit edit_patient_medical_condition_path(patient, condition)
      select 'Resolved', from: 'medical_condition[status]'
      click_button 'Salvar'
      
      expect(page).to have_content('Condição atualizada com sucesso')
    end

    scenario 'deletes condition' do
      condition = create(:medical_condition, 
        patient: patient, 
        condition_name: 'Hipertensão',
        diagnosed_date: Date.today)
      
      visit patient_medical_conditions_path(patient)
      
      expect {
        click_button 'Excluir', match: :first
      }.to change(MedicalCondition, :count).by(-1)
    end
  end
end
