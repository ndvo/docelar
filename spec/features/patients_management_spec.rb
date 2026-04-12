require 'rails_helper'

RSpec.describe 'Patients Management', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'Patient list' do
    scenario 'shows all patients filtered by type' do
      person = create(:person, name: 'Maria')
      patient = Patient.find_or_create_by!(individual: person)

      visit patients_path(type: 'Person')
      expect(page).to have_link('Maria')
    end

    scenario 'shows patients link to health hub' do
      person = create(:person, name: 'Joao')
      patient = Patient.find_or_create_by!(individual: person)

      visit patient_path(patient)
      expect(page).to have_content('Joao')
    end
  end

  describe 'Create patient' do
    scenario 'creates a new patient for a person' do
      person = create(:person, name: 'Ana')

      visit new_patient_path(type: 'Person')
      select 'Ana', from: 'patient[individual_id]'
      click_button 'Salvar'

      expect(page).to have_current_path(/\/patients\/\d+/)
      expect(page).to have_content('Ana')
    end

    scenario 'creates a new patient for a dog' do
      dog = create(:dog, name: 'Rex')

      visit new_patient_path(type: 'Dog')
      select 'Rex', from: 'patient[individual_id]'
      click_button 'Salvar'

      expect(page).to have_current_path(/\/patients\/\d+/)
      expect(page).to have_content('Rex')
    end
  end

  describe 'View patient' do
    scenario 'shows patient details' do
      person = create(:person, name: 'Carlos')
      patient = Patient.find_or_create_by!(individual: person)

      visit patient_path(patient)
      expect(page).to have_content('Carlos')
    end

    scenario 'shows health hub link' do
      person = create(:person, name: 'Fernanda')
      patient = Patient.find_or_create_by!(individual: person)

      visit patient_path(patient)
      expect(page).to have_link('Resumo de Saúde')
    end
  end

  describe 'Edit patient' do
    scenario 'updates patient' do
      person = create(:person, name: 'Pedro')
      patient = Patient.find_or_create_by!(individual: person)

      visit edit_patient_path(patient)
      click_button 'Salvar'

      patient.reload
      expect(patient.individual_type).to eq('Person')
    end
  end
end
