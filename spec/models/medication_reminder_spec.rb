require 'rails_helper'

RSpec.describe MedicationReminder, type: :model do
  describe 'associations' do
    it { should belong_to(:medication_administration) }
  end

  describe 'validations' do
    it { should validate_presence_of(:scheduled_at) }
  end

  describe 'status enum' do
    it 'defines pending, sent, acknowledged, snoozed statuses' do
      expect(MedicationReminder.statuses).to include('pending', 'sent', 'acknowledged', 'snoozed')
    end
  end

  describe 'scopes' do
    let(:admin) { create(:medication_administration) }
    let(:pending_reminder) { create(:medication_reminder, medication_administration: admin, status: :pending, scheduled_at: 1.hour.ago) }
    let(:snoozed_reminder) { create(:medication_reminder, medication_administration: admin, status: :snoozed, snoozed_until: 1.hour.from_now) }

    it 'has pending scope' do
      expect(MedicationReminder.respond_to?(:pending)).to be true
    end
  end

  describe '#mark_sent' do
    let(:reminder) { create(:medication_reminder, status: :pending) }

    it 'updates status to sent and sets sent_at' do
      reminder.mark_sent
      expect(reminder.status).to eq('sent')
      expect(reminder.sent_at).not_to be_nil
    end
  end

  describe '#acknowledge' do
    let(:reminder) { create(:medication_reminder, status: :sent) }

    it 'updates status to acknowledged and sets acknowledged_at' do
      reminder.acknowledge
      expect(reminder.status).to eq('acknowledged')
      expect(reminder.acknowledged_at).not_to be_nil
    end
  end

  describe '#snooze' do
    let(:reminder) { create(:medication_reminder, status: :pending) }

    it 'updates status to snoozed and sets snoozed_until' do
      reminder.snooze(minutes: 15)
      expect(reminder.status).to eq('snoozed')
      expect(reminder.snoozed_until).not_to be_nil
    end
  end
end