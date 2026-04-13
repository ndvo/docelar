require 'rails_helper'

RSpec.describe 'Medication Administration', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'quick administration' do
    let(:patient) do
      person = create(:person, name: 'Maria')
      Patient.find_or_create_by!(individual: person)
    end

    let!(:treatment) { create(:treatment, patient: patient, start_date: Date.today) }
    let!(:pharmacotherapy) { create(:pharmacotherapy, treatment: treatment) }
    let!(:administration) do
      create(:medication_administration, pharmacotherapy: pharmacotherapy,
             scheduled_at: Date.today.to_time + 10.hours, status: 'pending')
    end

    scenario 'marks dose as given' do
      visit patient_path(patient)
      
      expect(page).to have_button('Marcar como dado')
    end

    scenario 'skips dose with reason' do
      visit patient_path(patient)
      
      expect(page).to have_button('Pular')
    end
  end
end