require 'rails_helper'

RSpec.describe Habit, type: :model do
  let(:user) { create(:user) }
  let(:habit) { create(:habit, user: user) }

  describe "associations" do
    it { is_expected.to belong_to(:user).required }
    it { is_expected.to have_many(:habit_records).dependent(:destroy) }
  end

  describe "enums" do
    it "defines frequency_type enum" do
      expect(Habit.frequency_types).to eq({
        "daily" => 0, "weekly" => 1, "specific_days" => 2, "custom" => 3
      })
    end

    it "defines habit_type enum" do
      expect(Habit.habit_types).to eq({
        "personal" => 0, "family" => 1, "catholic_spiritual" => 2
      })
    end

    it "defines catholic_category enum" do
      expect(Habit.catholic_categories).to eq({
        "prayer" => 0, "mass" => 1, "rosary" => 2,
        "scripture" => 3, "volunteering" => 4, "other" => 5
      })
    end
  end

  describe "validations" do
    subject { build(:habit, user: user) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
  end

  describe "scopes" do
    let!(:active_habit) { create(:habit, user: user, active: true) }
    let!(:inactive_habit) { create(:habit, user: user, active: false) }

    describe ".active" do
      it "returns only active habits" do
        expect(Habit.active).to include(active_habit)
        expect(Habit.active).not_to include(inactive_habit)
      end
    end

    describe ".catholic" do
      let!(:catholic_habit) { create(:habit, user: user, habit_type: :catholic_spiritual) }

      it "returns catholic spiritual habits" do
        expect(Habit.catholic).to include(catholic_habit)
        expect(Habit.catholic).not_to include(active_habit)
      end
    end
  end

  describe "#completed_on?" do
    it "returns true when a completed record exists for the date" do
      create(:habit_record, habit: habit, record_date: Date.current, completed: true)
      expect(habit.completed_on?(Date.current)).to be true
    end

    it "returns false when no completed record exists" do
      expect(habit.completed_on?(Date.current)).to be false
    end
  end

  describe "#current_streak" do
    it "returns 0 when no records exist" do
      expect(habit.current_streak).to eq(0)
    end

    it "counts consecutive days ending today" do
      create(:habit_record, habit: habit, record_date: Date.current, completed: true)
      create(:habit_record, habit: habit, record_date: Date.yesterday, completed: true)
      create(:habit_record, habit: habit, record_date: 2.days.ago, completed: true)

      expect(habit.current_streak).to eq(3)
    end

    it "breaks streak when a day is missing" do
      create(:habit_record, habit: habit, record_date: Date.current, completed: true)
      create(:habit_record, habit: habit, record_date: 2.days.ago, completed: true)

      expect(habit.current_streak).to eq(1)
    end
  end

  describe "#longest_streak" do
    it "returns 0 when no records exist" do
      expect(habit.longest_streak).to eq(0)
    end

    it "finds the longest consecutive streak" do
      create(:habit_record, habit: habit, record_date: 5.days.ago, completed: true)
      create(:habit_record, habit: habit, record_date: 4.days.ago, completed: true)
      create(:habit_record, habit: habit, record_date: 3.days.ago, completed: true)
      create(:habit_record, habit: habit, record_date: 1.day.ago, completed: true)

      expect(habit.longest_streak).to eq(3)
    end
  end

  describe "#completion_percentage" do
    it "returns 0 when no records exist" do
      expect(habit.completion_percentage(30)).to eq(0.0)
    end

    it "calculates correct percentage" do
      create(:habit_record, habit: habit, record_date: 2.days.ago, completed: true)
      create(:habit_record, habit: habit, record_date: 1.day.ago, completed: true)
      create(:habit_record, habit: habit, record_date: Date.current, completed: true)

      expect(habit.completion_percentage(30)).to be > 0
    end
  end
end
