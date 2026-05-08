require 'rails_helper'

RSpec.describe "TaskLogEntries", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:task_log) { create(:task_log, user: user) }
  let(:task) { create(:task) }
  let(:entry) { create(:task_log_entry, task_log: task_log, task: task, position: 1) }

  before do
    post login_path, params: { email_address: user.email_address, password: "password123" }
  end

  describe "PATCH /task_log_entries/:id/update_position" do
    let!(:entry1) { create(:task_log_entry, task_log: task_log, position: 1) }
    let!(:entry2) { create(:task_log_entry, task_log: task_log, position: 2) }
    let!(:entry3) { create(:task_log_entry, task_log: task_log, position: 3) }

    it "updates the position of an entry" do
      patch update_position_task_log_entry_path(entry1), params: { position: 3 }
      expect(response).to have_http_status(:ok)
      expect(entry1.reload.position).to eq(3)
    end

    it "reorders other entries when moving down" do
      # Move entry1 from position 1 to position 3
      patch update_position_task_log_entry_path(entry1), params: { position: 3 }

      expect(entry1.reload.position).to eq(3)
      expect(entry2.reload.position).to eq(1)
      expect(entry3.reload.position).to eq(2)
    end

    it "reorders other entries when moving up" do
      # Move entry3 from position 3 to position 1
      patch update_position_task_log_entry_path(entry3), params: { position: 1 }

      expect(entry3.reload.position).to eq(1)
      expect(entry1.reload.position).to eq(2)
      expect(entry2.reload.position).to eq(3)
    end

    it "returns forbidden for entry belonging to another user" do
      other_log = create(:task_log, user: other_user)
      other_entry = create(:task_log_entry, task_log: other_log)
      patch update_position_task_log_entry_path(other_entry), params: { position: 5 }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /task_log_entries/:id" do
    let(:entry) { create(:task_log_entry, task_log: task_log, status: :pending) }

    it "updates entry status" do
      patch task_log_entry_path(entry), params: { task_log_entry: { status: :completed } }
      entry.reload
      expect(entry).to be_status_completed
    end

    it "updates time_spent" do
      patch task_log_entry_path(entry), params: { task_log_entry: { time_spent: 1800 } }
      entry.reload
      expect(entry.time_spent).to eq(1800)
    end

    it "updates notes" do
      patch task_log_entry_path(entry), params: { task_log_entry: { notes: "Updated notes" } }
      entry.reload
      expect(entry.notes).to eq("Updated notes")
    end

    it "redirects back after update" do
      patch task_log_entry_path(entry), params: { task_log_entry: { status: :in_progress } }
      expect(response).to redirect_to(task_log_path(task_log))
    end
  end

  describe "DELETE /task_log_entries/:id" do
    let!(:entry_to_delete) { create(:task_log_entry, task_log: task_log) }

    it "removes the entry from the log" do
      expect {
        delete task_log_entry_path(entry_to_delete)
      }.to change(TaskLogEntry, :count).by(-1)
    end

    it "redirects to the task log" do
      delete task_log_entry_path(entry_to_delete)
      expect(response).to redirect_to(task_log_path(task_log))
    end

    it "does not allow deleting another user's entry" do
      other_log = create(:task_log, user: other_user)
      other_entry = create(:task_log_entry, task_log: other_log)

      delete task_log_entry_path(other_entry)
      expect(response).to redirect_to(task_logs_path)
    end
  end
end
