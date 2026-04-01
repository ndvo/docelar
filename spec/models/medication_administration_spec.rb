require 'rails_helper'

RSpec.describe MedicationAdministration, type: :model do
  describe 'associations' do
    it { should belong_to(:pharmacotherapy) }
  end

  describe 'status enum' do
    it 'defines pending, given, skipped, missed statuses' do
      expect(MedicationAdministration.statuses).to include('pending', 'given', 'skipped', 'missed')
    end
  end

  describe 'validations' do
    it 'requires scheduled_at datetime' do
      expect(build(:medication_administration, scheduled_at: nil)).not_to be_valid
    end
  end

  describe 'scopes' do
    it 'has for_today scope' do
      expect(MedicationAdministration.respond_to?(:for_today)).to be true
    end
  end
end
