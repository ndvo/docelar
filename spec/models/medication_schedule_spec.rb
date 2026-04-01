require 'rails_helper'

RSpec.describe MedicationSchedule, type: :model do
  describe 'associations' do
    it { should belong_to(:pharmacotherapy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:schedule_type) }
    it { should validate_presence_of(:times) }
  end

  describe 'schedule_type enum' do
    it 'defines daily, interval, weekly types' do
      expect(MedicationSchedule.schedule_types).to include('daily', 'interval', 'weekly')
    end
  end
end
