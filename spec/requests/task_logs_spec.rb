require 'rails_helper'

RSpec.describe "TaskLogs", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    # For request specs, we need to post directly to the session endpoint
    post login_path, params: { email_address: user.email_address, password: "password123" }
  end

  describe "GET /task_logs" do
    let!(:task_log1) { create(:task_log, user: user, log_date: Date.yesterday) }
    let!(:task_log2) { create(:task_log, user: user, log_date: Date.current) }

    it "returns success" do
      get task_logs_path
      expect(response).to have_http_status(:success)
    end

    it "displays user's task logs" do
      get task_logs_path
      expect(response.body).to include(task_log1.title)
      expect(response.body).to include(task_log2.title)
    end

    it "does not display other user's logs" do
      other_log = create(:task_log, user: other_user, title: "UNIQUE_OTHER_LOG_TITLE_XYZ")
      get task_logs_path
      expect(response.body).not_to include("UNIQUE_OTHER_LOG_TITLE_XYZ")
    end
  end

  describe "GET /task_logs/:id" do
    let(:task_log) { create(:task_log, user: user) }

    it "returns success when accessing own log" do
      get task_log_path(task_log)
      expect(response).to have_http_status(:success)
    end

    it "redirects when accessing another user's log" do
      other_log = create(:task_log, user: other_user)
      get task_log_path(other_log)
      expect(response).to redirect_to(task_logs_path)
    end
  end

  describe "GET /task_logs/new" do
    it "returns success" do
      get new_task_log_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /task_logs" do
    let(:valid_attributes) { { log_date: Date.current, title: "Today's Tasks", status: :draft } }

    context "with valid parameters" do
      it "creates a new TaskLog" do
        expect {
          post task_logs_path, params: { task_log: valid_attributes }
        }.to change(TaskLog, :count).by(1)
      end

      it "redirects to the created task log" do
        post task_logs_path, params: { task_log: valid_attributes }
        expect(response).to redirect_to(TaskLog.last)
      end

      it "sets the user to current user" do
        post task_logs_path, params: { task_log: valid_attributes }
        expect(TaskLog.last.user).to eq(user)
      end
    end

    context "with invalid parameters" do
      it "does not create a new TaskLog without log_date" do
        expect {
          post task_logs_path, params: { task_log: { title: "Test", log_date: nil } }
        }.not_to change(TaskLog, :count)
      end

      it "re-renders the new template" do
        post task_logs_path, params: { task_log: { title: "Test", log_date: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with duplicate date for same user" do
      let!(:existing_log) { create(:task_log, user: user, log_date: Date.current) }

      it "does not create a new TaskLog" do
        expect {
          post task_logs_path, params: { task_log: { log_date: Date.current, title: "Another" } }
        }.not_to change(TaskLog, :count)
      end
    end
  end

  describe "GET /task_logs/:id/edit" do
    let(:task_log) { create(:task_log, user: user) }

    it "returns success" do
      get edit_task_log_path(task_log)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /task_logs/:id" do
    let(:task_log) { create(:task_log, user: user, title: "Old Title") }

    it "updates the task log" do
      patch task_log_path(task_log), params: { task_log: { title: "New Title" } }
      task_log.reload
      expect(task_log.title).to eq("New Title")
    end

    it "redirects to the task log" do
      patch task_log_path(task_log), params: { task_log: { title: "New Title" } }
      expect(response).to redirect_to(task_log)
    end
  end

  describe "DELETE /task_logs/:id" do
    let!(:task_log) { create(:task_log, user: user) }

    it "destroys the task log" do
      expect {
        delete task_log_path(task_log)
      }.to change(TaskLog, :count).by(-1)
    end

    it "redirects to task logs path" do
      delete task_log_path(task_log)
      expect(response).to redirect_to(task_logs_path)
    end
  end

  describe "GET /task_logs/today" do
    context "when no log exists for today" do
      it "creates a new log for today" do
        expect {
          get today_task_logs_path
        }.to change(TaskLog, :count).by(1)

        log = TaskLog.last
        expect(log.log_date).to eq(Date.current)
        expect(log.user).to eq(user)
      end

      it "redirects to the new log" do
        get today_task_logs_path
        expect(response).to redirect_to(TaskLog.last)
      end
    end

    context "when a log already exists for today" do
      let!(:existing_log) { create(:task_log, user: user, log_date: Date.current) }

      it "does not create a new log" do
        expect {
          get today_task_logs_path
        }.not_to change(TaskLog, :count)
      end

      it "redirects to the existing log" do
        get today_task_logs_path
        expect(response).to redirect_to(existing_log)
      end
    end
  end
end
