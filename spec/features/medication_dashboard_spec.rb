require 'rails_helper'

RSpec.describe 'Medication Dashboard', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'patient type toggle' do
    scenario 'shows people and dogs as separate sections' do
      person = create(:person, name: 'Joao')
      patient = Patient.find_or_create_by!(individual: person)
      dog = create(:dog, name: 'Buddy')
      visit patients_path(type: 'Person')
      expect(page).to have_content('Medicamentos')
      expect(page).to have_link('Joao')
    end
  end

  describe 'dashboard medication summary' do
    scenario 'shows active treatments with next dose time' do
      person = create(:person, name: 'Maria')
      patient = Patient.find_or_create_by!(individual: person)
      treatment = create(:treatment, patient: patient, start_date: Date.today)
      pharmacotherapy = create(:pharmacotherapy, treatment: treatment)
      
      visit patient_path(patient)
      expect(page).to have_content(treatment.name)
    end
  end

  describe 'today medications' do
    scenario 'lists today doses' do
      person = create(:person, name: 'Pedro')
      patient = Patient.find_or_create_by!(individual: person)
      treatment = create(:treatment, patient: patient, start_date: Date.today)
      pharmacotherapy = create(:pharmacotherapy, treatment: treatment)
      administration = create(:medication_administration, pharmacotherapy: pharmacotherapy, 
                            scheduled_at: Time.current, status: 'pending')
      
      visit patient_path(patient)
      expect(page).to have_content(pharmacotherapy.medication.name)
    end
  end
end