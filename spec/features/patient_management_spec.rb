require 'rails_helper'

RSpec.describe 'Patient Management', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'new patient form' do
    scenario 'shows patient type selection' do
      visit new_patient_path
      expect(page).to have_content('Tipo de Paciente')
    end

    scenario 'selects Dog type shows non-patient dogs' do
      dog = create(:dog, name: 'Buddy')
      
      visit new_patient_path(type: 'Dog')
      expect(page).to have_content('Buddy')
    end

    scenario 'selects Person type shows non-patient people' do
      person = create(:person, name: 'Maria')
      
      visit new_patient_path(type: 'Person')
      expect(page).to have_content('Maria')
    end

    scenario 'excludes existing patients from list' do
      person = create(:person, name: 'Maria')
      _patient = Patient.find_or_create_by!(individual: person)
      
      visit new_patient_path(type: 'Person')
      expect(page).not_to have_content('Maria')
    end

    scenario 'creates dog patient' do
      dog = create(:dog, name: 'Buddy')
      
      visit new_patient_path(type: 'Dog')
      select 'Buddy', from: 'patient[individual_id]'
      click_button 'Salvar'
      
      expect(Patient.last.individual_type).to eq('Dog')
    end

    scenario 'creates person patient' do
      person = create(:person, name: 'Maria')
      
      visit new_patient_path(type: 'Person')
      select 'Maria', from: 'patient[individual_id]'
      click_button 'Salvar'
      
      expect(Patient.last.individual_type).to eq('Person')
    end
  end

  describe 'create patient from dog show page' do
    scenario 'shows button to become patient when dog has no patient record' do
      dog = create(:dog, name: 'Buddy')
      
      visit dog_path(dog)
      expect(page).to have_button('Tornar Paciente')
    end

    scenario 'creates patient with one click' do
      dog = create(:dog, name: 'Buddy')
      
      visit dog_path(dog)
      
      expect { click_button 'Tornar Paciente' }.to change(Patient, :count).by(1)
      expect(Patient.last.individual).to eq(dog)
    end
  end

  describe 'create patient from person show page' do
    scenario 'shows button to become patient when person has no patient record' do
      person = create(:person, name: 'Maria')
      
      visit person_path(person)
      expect(page).to have_button('Tornar Paciente')
    end

    scenario 'creates patient with one click' do
      person = create(:person, name: 'Maria')
      
      visit person_path(person)
      
      expect { click_button 'Tornar Paciente' }.to change(Patient, :count).by(1)
      expect(Patient.last.individual).to eq(person)
    end
  end
end
