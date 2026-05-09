require 'rails_helper'

RSpec.describe HabitRecord, type: :model do
  let(:habit) { create(:habit) }

  describe "associations" do
    it { is_expected.to belong_to(:habit).required }
  end

  describe "validations" do
    subject { build(:habit_record, habit: habit) }

    it { is_expected.to validate_presence_of(:record_date) }
    it { is_expected.to validate_uniqueness_of(:record_date).scoped_to(:habit_id) }
  end

  describe "scopes" do
    let!(:record_today) { create(:habit_record, habit: habit, record_date: Date.current, completed: true) }
    let!(:record_yesterday) { create(:habit_record, habit: habit, record_date: Date.yesterday, completed: false) }

    describe ".completed" do
      it "returns only completed records" do
        expect(HabitRecord.completed).to include(record_today)
        expect(HabitRecord.completed).not_to include(record_yesterday)
      end
    end

    describe ".for_date" do
      it "returns records for a specific date" do
        expect(HabitRecord.for_date(Date.current)).to include(record_today)
        expect(HabitRecord.for_date(Date.current)).not_to include(record_yesterday)
      end
    end

    describe ".ordered" do
      it "returns records ordered by date descending" do
        expect(HabitRecord.ordered.first).to eq(record_today)
      end
    end
  end
end
