require 'rails_helper'

RSpec.describe 'Medication Reminders', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:medication) { create(:medication) }
  let(:patient) { create(:patient) }
  let(:treatment) { create(:treatment, patient: patient) }
  let(:pharmacotherapy) { create(:pharmacotherapy, treatment: treatment, medication: medication) }
  let(:administration) { create(:medication_administration, pharmacotherapy: pharmacotherapy) }

  before { login_as(user) }

  scenario 'creates a reminder when administration is scheduled' do
    visit treatment_path(treatment)
    expect(page).to have_content('Medicações')
  end

  scenario 'acknowledges a reminder' do
    reminder = create(:medication_reminder, medication_administration: administration, status: :sent)
    visit medication_reminder_path(reminder)
    click_button 'Acknowledge'
    expect(reminder.reload.status).to eq('acknowledged')
  end

  scenario 'snoozes a reminder' do
    reminder = create(:medication_reminder, medication_administration: administration, status: :sent)
    visit medication_reminder_path(reminder)
    fill_in 'minutes', with: 15
    click_button 'Snooze'
    expect(reminder.reload.status).to eq('snoozed')
    expect(reminder.snoozed_until).not_to be_nil
  end
end