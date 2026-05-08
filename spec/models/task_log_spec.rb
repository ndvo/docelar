require 'rails_helper'

RSpec.describe TaskLog, type: :model do
  let(:user) { create(:user) }

  describe "associations" do
    it { is_expected.to belong_to(:user).required }
    it { is_expected.to have_many(:task_log_entries).dependent(:destroy) }
    it { is_expected.to have_many(:tasks).through(:task_log_entries) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:log_date) }

    describe "uniqueness validation" do
      let!(:existing_log) { create(:task_log, user: user, log_date: Date.current) }

      it "validates uniqueness of log_date scoped to user" do
        duplicate_log = build(:task_log, user: user, log_date: Date.current)
        expect(duplicate_log).not_to be_valid
        expect(duplicate_log.errors[:log_date]).to be_present
      end

      it "allows different users to have logs on the same date" do
        other_user = create(:user)
        other_log = build(:task_log, user: other_user, log_date: Date.current)
        expect(other_log).to be_valid
      end
    end
  end

  describe "enums" do
    it "defines status enum with correct values" do
      expect(TaskLog.statuses).to eq({
        "draft" => 0,
        "active" => 1,
        "completed" => 2
      })
    end

    it "responds to status methods" do
      task_log = build(:task_log, status: :draft)
      expect(task_log).to be_status_draft
      expect(task_log).not_to be_status_active
    end
  end

  describe "scopes" do
    let!(:log_today) { create(:task_log, user: user, log_date: Date.current) }
    let!(:log_yesterday) { create(:task_log, user: user, log_date: Date.yesterday) }
    let!(:log_tomorrow) { create(:task_log, user: user, log_date: Date.tomorrow) }

    describe ".for_date" do
      it "returns logs for a specific date" do
        expect(TaskLog.for_date(Date.current)).to include(log_today)
        expect(TaskLog.for_date(Date.current)).not_to include(log_yesterday, log_tomorrow)
      end
    end

    describe ".today" do
      it "returns logs for today" do
        expect(TaskLog.today).to include(log_today)
        expect(TaskLog.today).not_to include(log_yesterday, log_tomorrow)
      end
    end

    describe ".by_date_desc" do
      it "returns logs ordered by date descending" do
        logs = TaskLog.by_date_desc
        expect(logs.to_a).to eq([log_tomorrow, log_today, log_yesterday])
      end
    end
  end

  describe ".find_or_create_for_today" do
    context "when no log exists for today" do
      it "creates a new log for today" do
        expect {
          TaskLog.find_or_create_for_today(user)
        }.to change(TaskLog, :count).by(1)

        log = TaskLog.last
        expect(log.log_date).to eq(Date.current)
        expect(log.user).to eq(user)
        expect(log).to be_status_draft
      end
    end

    context "when a log already exists for today" do
      let!(:existing_log) { create(:task_log, user: user, log_date: Date.current) }

      it "returns the existing log without creating a new one" do
        expect {
          TaskLog.find_or_create_for_today(user)
        }.not_to change(TaskLog, :count)

        expect(TaskLog.find_or_create_for_today(user)).to eq(existing_log)
      end
    end
  end

  describe "#total_time_spent" do
    let(:task_log) { create(:task_log, user: user) }
    let(:task1) { create(:task) }
    let(:task2) { create(:task) }

    before do
      create(:task_log_entry, task_log: task_log, task: task1, time_spent: 1200)
      create(:task_log_entry, task_log: task_log, task: task2, time_spent: 1800)
    end

    it "returns the sum of time_spent across all entries" do
      expect(task_log.total_time_spent).to eq(3000)
    end
  end

  describe "#completed_entries_count" do
    let(:task_log) { create(:task_log, user: user) }

    before do
      create(:task_log_entry, task_log: task_log, status: :completed)
      create(:task_log_entry, task_log: task_log, status: :completed)
      create(:task_log_entry, task_log: task_log, status: :pending)
    end

    it "returns the count of completed entries" do
      expect(task_log.completed_entries_count).to eq(2)
    end
  end

  describe "#total_entries_count" do
    let(:task_log) { create(:task_log, user: user) }

    before do
      3.times { create(:task_log_entry, task_log: task_log) }
    end

    it "returns the total number of entries" do
      expect(task_log.total_entries_count).to eq(3)
    end
  end
end

