require 'rails_helper'

RSpec.describe 'Treatment Management', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'treatment list' do
    scenario 'shows all treatments' do
      person = create(:person, name: 'Maria')
      patient = Patient.find_or_create_by!(individual: person)
      create(:treatment, patient: patient, name: 'Infection Treatment', start_date: Date.today)
      
      visit treatments_path
      expect(page).to have_content('Infection Treatment')
    end
  end

  describe 'new treatment form' do
    scenario 'shows patient selection' do
      person = create(:person)
      patient = Patient.find_or_create_by!(individual: person)
      visit new_patient_treatment_path(patient)
      expect(page).to have_content('Nome do Tratamento')
    end

    scenario 'creates treatment without medications' do
      person = create(:person)
      patient = Patient.find_or_create_by!(individual: person)
      
      visit new_patient_treatment_path(patient)
      fill_in 'treatment[name]', with: 'Physical Therapy'
      fill_in 'treatment[start_date]', with: Date.today
      click_button 'Salvar'
      
      expect(Treatment.count).to eq(1)
      expect(Treatment.last.name).to eq('Physical Therapy')
      expect(Treatment.last.pharmacotherapies).to be_empty
    end

    scenario 'creates treatment with pharmacotherapy' do
      person = create(:person)
      patient = Patient.find_or_create_by!(individual: person)
      _medication = create(:medication, name: 'Antibiotic')
      
      visit new_patient_treatment_path(patient)
      
      fill_in 'treatment[name]', with: 'Infection Treatment'
      fill_in 'treatment[start_date]', with: Date.today
      
      click_button 'Salvar'
      
      expect(Treatment.count).to eq(1)
      expect(Treatment.last.name).to eq('Infection Treatment')
    end
  end
end