require 'rails_helper'

RSpec.describe 'Medication Administration', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'quick administration' do
    scenario 'marks dose as given' do
      person = create(:person, name: 'Maria')
      patient = Patient.find_or_create_by!(individual: person)
      treatment = create(:treatment, patient: patient, start_date: Date.today)
      pharmacotherapy = create(:pharmacotherapy, treatment: treatment)
      administration = create(:medication_administration, pharmacotherapy: pharmacotherapy,
                           scheduled_at: Time.current, status: 'pending')
      
      visit patient_path(patient)
      
      expect(page).to have_button('Marcar como dado')
    end

    scenario 'skips dose with reason' do
      person = create(:person, name: 'Maria')
      patient = Patient.find_or_create_by!(individual: person)
      treatment = create(:treatment, patient: patient, start_date: Date.today)
      pharmacotherapy = create(:pharmacotherapy, treatment: treatment)
      administration = create(:medication_administration, pharmacotherapy: pharmacotherapy,
                           scheduled_at: Time.current, status: 'pending')
      
      visit patient_path(patient)
      
      expect(page).to have_button('Pular')
    end
  end
end