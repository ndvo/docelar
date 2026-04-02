require 'rails_helper'

RSpec.describe 'Medication Reminders', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'reminder page' do
    scenario 'shows reminder details' do
      person = create(:person, name: 'Maria')
      patient = Patient.find_or_create_by!(individual: person)
      treatment = create(:treatment, patient: patient, start_date: Date.today)
      pharmacotherapy = create(:pharmacotherapy, treatment: treatment)
      administration = create(:medication_administration, pharmacotherapy: pharmacotherapy)
      reminder = create(:medication_reminder, medication_administration: administration, status: :sent)
      
      visit medication_reminder_path(reminder)
      expect(page).to have_content('Lembrete de Medicamento')
      expect(page).to have_button('Confirmar')
      expect(page).to have_button('Adiar')
    end
  end

  describe 'reminder actions' do
    scenario 'acknowledges a reminder' do
      person = create(:person, name: 'Maria')
      patient = Patient.find_or_create_by!(individual: person)
      treatment = create(:treatment, patient: patient, start_date: Date.today)
      pharmacotherapy = create(:pharmacotherapy, treatment: treatment)
      administration = create(:medication_administration, pharmacotherapy: pharmacotherapy)
      reminder = create(:medication_reminder, medication_administration: administration, status: :sent)
      
      visit medication_reminder_path(reminder)
      click_button 'Confirmar'
      
      expect(reminder.reload.status).to eq('acknowledged')
    end

    scenario 'snoozes a reminder' do
      person = create(:person, name: 'Maria')
      patient = Patient.find_or_create_by!(individual: person)
      treatment = create(:treatment, patient: patient, start_date: Date.today)
      pharmacotherapy = create(:pharmacotherapy, treatment: treatment)
      administration = create(:medication_administration, pharmacotherapy: pharmacotherapy)
      reminder = create(:medication_reminder, medication_administration: administration, status: :sent)
      
      visit medication_reminder_path(reminder)
      fill_in 'reminder[minutes]', with: 30
      click_button 'Adiar'
      
      expect(reminder.reload.status).to eq('snoozed')
      expect(reminder.snoozed_until).not_to be_nil
    end
  end
end