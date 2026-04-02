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

  describe '#generate_administrations' do
    let(:pharmacotherapy) { create(:pharmacotherapy) }
    let(:schedule) do
      create(:medication_schedule,
        pharmacotherapy: pharmacotherapy,
        schedule_type: :daily,
        times: ['08:00', '20:00'],
        start_date: Date.today - 1.day,
        enabled: true)
    end

    it 'generates administrations for each time in the date range' do
      administrations = schedule.generate_administrations(
        from_date: Date.today,
        to_date: Date.today + 2.days,
        include_past: true
      )
      
      expect(administrations.size).to eq(6)
    end

    it 'creates pending administrations' do
      administrations = schedule.generate_administrations(
        from_date: Date.today,
        to_date: Date.today,
        include_past: true
      )
      
      expect(administrations.all? { |a| a.status == 'pending' }).to be true
    end

    it 'respects start_date boundary' do
      schedule.update(start_date: Date.today + 1.day)
      
      administrations = schedule.generate_administrations(
        from_date: Date.today,
        to_date: Date.today + 2.days,
        include_past: true
      )
      
      expect(administrations.size).to eq(4)
    end

    it 'respects end_date boundary' do
      schedule.update(end_date: Date.today)
      
      administrations = schedule.generate_administrations(
        from_date: Date.today,
        to_date: Date.today + 2.days,
        include_past: true
      )
      
      expect(administrations.size).to eq(2)
    end
  end
end
