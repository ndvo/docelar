require 'rails_helper'

RSpec.describe TaskLogEntry, type: :model do
  let(:task_log) { create(:task_log) }
  let(:task) { create(:task) }

  describe "associations" do
    it { is_expected.to belong_to(:task_log).required }
    it { is_expected.to belong_to(:task).required }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:position) }

    describe "uniqueness validation" do
      let!(:existing_entry) { create(:task_log_entry, task_log: task_log, task: task) }

      it "validates uniqueness of task_id scoped to task_log_id" do
        duplicate_entry = build(:task_log_entry, task_log: task_log, task: task)
        expect(duplicate_entry).not_to be_valid
        expect(duplicate_entry.errors[:task_id]).to be_present
      end

      it "allows same task in different logs" do
        other_log = create(:task_log)
        other_entry = build(:task_log_entry, task_log: other_log, task: task)
        expect(other_entry).to be_valid
      end
    end
  end

  describe "enums" do
    it "defines status enum with correct values" do
      expect(TaskLogEntry.statuses).to eq({
        "pending" => 0,
        "in_progress" => 1,
        "completed" => 2,
        "cancelled" => 3
      })
    end

    it "responds to status methods" do
      entry = build(:task_log_entry, status: :pending)
      expect(entry).to be_status_pending
      expect(entry).not_to be_status_in_progress
    end
  end

  describe "scopes" do
    let!(:pending_entry) { create(:task_log_entry, status: :pending) }
    let!(:in_progress_entry) { create(:task_log_entry, status: :in_progress) }
    let!(:completed_entry) { create(:task_log_entry, status: :completed) }
    let!(:cancelled_entry) { create(:task_log_entry, status: :cancelled) }

    describe ".ordered" do
      let(:log) { create(:task_log) }
      let!(:entry1) { create(:task_log_entry, task_log: log, position: 2) }
      let!(:entry2) { create(:task_log_entry, task_log: log, position: 1) }
      let!(:entry3) { create(:task_log_entry, task_log: log, position: 3) }

      it "returns entries ordered by position ascending" do
        expect(log.task_log_entries.ordered.to_a).to eq([entry2, entry1, entry3])
      end
    end

    describe ".pending" do
      it "returns pending entries" do
        expect(TaskLogEntry.pending).to include(pending_entry)
        expect(TaskLogEntry.pending).not_to include(in_progress_entry, completed_entry, cancelled_entry)
      end
    end

    describe ".in_progress" do
      it "returns in_progress entries" do
        expect(TaskLogEntry.in_progress).to include(in_progress_entry)
        expect(TaskLogEntry.in_progress).not_to include(pending_entry, completed_entry, cancelled_entry)
      end
    end

    describe ".completed" do
      it "returns completed entries" do
        expect(TaskLogEntry.completed).to include(completed_entry)
        expect(TaskLogEntry.completed).not_to include(pending_entry, in_progress_entry, cancelled_entry)
      end
    end

    describe ".active" do
      it "returns pending and in_progress entries" do
        expect(TaskLogEntry.active).to include(pending_entry, in_progress_entry)
        expect(TaskLogEntry.active).not_to include(completed_entry, cancelled_entry)
      end
    end
  end

  describe "callbacks" do
    describe "before_validation :set_position" do
      context "when position is blank" do
        let(:log) { create(:task_log) }

        it "sets position to max + 1" do
          create(:task_log_entry, task_log: log, position: 3)
          entry = build(:task_log_entry, task_log: log, position: nil)
          entry.valid?
          expect(entry.position).to eq(4)
        end
      end

      context "when position is already set" do
        it "does not change position" do
          entry = build(:task_log_entry, position: 5)
          entry.valid?
          expect(entry.position).to eq(5)
        end
      end

      context "when task_log is nil" do
        it "does not set position" do
          entry = build(:task_log_entry, task_log: nil, position: nil)
          entry.valid?
          expect(entry.position).to be_nil
        end
      end
    end
  end

  describe "#time_spent_in_minutes" do
    it "returns time_spent converted to minutes" do
      entry = build(:task_log_entry, time_spent: 3600)
      expect(entry.time_spent_in_minutes).to eq(60)
    end

    it "returns nil if time_spent is nil" do
      entry = build(:task_log_entry, time_spent: nil)
      expect(entry.time_spent_in_minutes).to be_nil
    end
  end

  describe "#time_spent_display" do
    it "formats time in hours and minutes" do
      entry = build(:task_log_entry, time_spent: 5400) # 1h 30min
      expect(entry.time_spent_display).to eq("1h 30min")
    end

    it "formats time in minutes only when less than an hour" do
      entry = build(:task_log_entry, time_spent: 1800)
      expect(entry.time_spent_display).to eq("30 min")
    end

    it "returns 0 min for zero time" do
      entry = build(:task_log_entry, time_spent: 0)
      expect(entry.time_spent_display).to eq("0 min")
    end
  end
end
