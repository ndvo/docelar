require "rails_helper"

RSpec.describe "PomodoroSessions", type: :request do
  let(:user) { create(:user) }
  let(:task) { create(:task) }
  let(:project) { create(:project, user: user) }
  let(:pomodoro_session) { create(:pomodoro_session, user: user, task: task, project: project) }

  before do
    # Authenticate user via session (matching ApplicationController)
    post login_path, params: { email_address: user.email_address, password: "password123" }
  end

  describe "GET /pomodoro_sessions" do
    context "when user has sessions" do
      before do
        create_list(:pomodoro_session, 3, user: user)
      end

      it "returns successful response" do
        get pomodoro_sessions_path
        expect(response).to be_successful
      end

      it "renders sessions list" do
        get pomodoro_sessions_path
        expect(response.body).to include("Pomodoro Sessions")
      end
    end

    context "when user has no sessions" do
      it "returns successful response" do
        get pomodoro_sessions_path
        expect(response).to be_successful
      end
    end
  end

  describe "GET /pomodoro_sessions/statistics" do
    before do
      create(:pomodoro_session, :completed, user: user, task: task, duration: 1500)
      create(:pomodoro_session, :completed, user: user, task: task, duration: 1500)
    end

    it "returns successful response" do
      get statistics_pomodoro_sessions_path
      expect(response).to be_successful
    end

    it "renders statistics page" do
      get statistics_pomodoro_sessions_path
      expect(response.body).to include("Pomodoro Statistics")
    end
  end

  describe "GET /pomodoro_sessions/new" do
    it "returns successful response" do
      get new_pomodoro_session_path
      expect(response).to be_successful
    end

    it "renders new session form" do
      get new_pomodoro_session_path
      expect(response.body).to include("New Pomodoro Session")
    end
  end

  describe "POST /pomodoro_sessions" do
    let(:valid_attributes) do
      {
        pomodoro_session: {
          task_id: task.id,
          project_id: project.id,
          duration: 1500,
          status: :planned
        }
      }
    end

    context "with valid parameters" do
      it "creates a new PomodoroSession" do
        expect {
          post pomodoro_sessions_path, params: valid_attributes
        }.to change(PomodoroSession, :count).by(1)
      end

      it "redirects to the created session" do
        post pomodoro_sessions_path, params: valid_attributes
        expect(response).to redirect_to(pomodoro_session_path(PomodoroSession.last))
      end
    end
  end

  describe "GET /pomodoro_sessions/1" do
    it "returns successful response" do
      get pomodoro_session_path(pomodoro_session)
      expect(response).to be_successful
    end

    it "renders session details" do
      get pomodoro_session_path(pomodoro_session)
      expect(response.body).to include("Pomodoro Session Details")
    end
  end

  describe "POST /pomodoro_sessions/start" do
    context "when no active session exists" do
      it "creates a new in-progress session" do
        expect {
          post start_pomodoro_sessions_path(task_id: task.id)
        }.to change(PomodoroSession, :count).by(1)
      end

      it "sets status to in_progress" do
        post start_pomodoro_sessions_path(task_id: task.id)
        expect(PomodoroSession.last.status).to eq('in_progress')
      end
    end
  end

  describe "POST /pomodoro_sessions/1/complete" do
    let!(:active_session) { create(:pomodoro_session, :in_progress, user: user, task: task) }

    it "completes the session" do
      post complete_pomodoro_session_path(active_session)
      active_session.reload
      expect(active_session.status).to eq('completed')
    end
  end

  describe "DELETE /pomodoro_sessions/1" do
    let!(:session_to_delete) { create(:pomodoro_session, user: user) }

    it "destroys the session" do
      expect {
        delete pomodoro_session_path(session_to_delete)
      }.to change(PomodoroSession, :count).by(-1)
    end
  end
end
