require 'rails_helper'

RSpec.describe PomodoroSession, type: :model do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password123') }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:task).optional }
    it { is_expected.to belong_to(:project).optional }
  end

  describe 'enums' do
    it 'defines status enum' do
      expect(PomodoroSession.statuses).to eq({'planned' => 0, 'in_progress' => 1, 'completed' => 2, 'cancelled' => 3})
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_numericality_of(:duration).is_greater_than(0).allow_nil }
    it { is_expected.to validate_numericality_of(:interruptions).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe 'scopes' do
    let!(:session_today) { PomodoroSession.create!(user: user, started_at: Time.current, status: :in_progress) }
    let!(:session_yesterday) { PomodoroSession.create!(user: user, started_at: 1.day.ago, status: :completed, duration: 1500) }
    let!(:session_planned) { PomodoroSession.create!(user: user, status: :planned) }
    let!(:session_cancelled) { PomodoroSession.create!(user: user, status: :cancelled) }

    describe '.today' do
      it 'returns sessions from today' do
        expect(PomodoroSession.today).to include(session_today)
        expect(PomodoroSession.today).not_to include(session_yesterday)
      end
    end

    describe '.completed' do
      it 'returns only completed sessions' do
        expect(PomodoroSession.completed).to include(session_yesterday)
        expect(PomodoroSession.completed).not_to include(session_today, session_planned, session_cancelled)
      end
    end

    describe '.for_task' do
      let(:task) { Task.create!(status: 'planned') }
      let!(:task_session) { PomodoroSession.create!(user: user, task: task, status: :completed, duration: 1500) }

      it 'returns sessions for a specific task' do
        expect(PomodoroSession.for_task(task)).to include(task_session)
      end
    end

    describe '.for_project' do
      let(:project) { Project.create!(name: 'Test Project', user: user) }
      let!(:project_session) { PomodoroSession.create!(user: user, project: project, status: :completed, duration: 1500) }

      it 'returns sessions for a specific project' do
        expect(PomodoroSession.for_project(project)).to include(project_session)
      end
    end
  end

  describe '#elapsed_time' do
    it 'returns 0 if not in progress' do
      session = PomodoroSession.create!(user: user, status: :completed, duration: 1500)
      expect(session.elapsed_time).to eq(0)
    end

    it 'returns elapsed time if in progress and started_at is set' do
      session = PomodoroSession.create!(user: user, status: :in_progress, started_at: 5.minutes.ago)
      expect(session.elapsed_time).to be_within(1).of(300)
    end
  end

  describe '#complete!' do
    let(:session) { PomodoroSession.create!(user: user, status: :in_progress, started_at: 25.minutes.ago) }

    it 'sets ended_at to current time' do
      session.complete!
      expect(session.ended_at).to be_present
    end

    it 'sets status to completed' do
      session.complete!
      expect(session.status).to eq('completed')
    end

    it 'sets duration to elapsed time' do
      session.complete!
      expect(session.duration).to be_present
      expect(session.duration).to be_within(1).of(1500)
    end
  end

  describe '#log_interruption!' do
    let(:session) { PomodoroSession.create!(user: user, status: :in_progress, interruptions: 0) }

    it 'increments interruptions' do
      expect { session.log_interruption! }.to change { session.reload.interruptions }.by(1)
    end
  end

  describe '#active?' do
    it 'returns true for in_progress status' do
      session = PomodoroSession.create!(user: user, status: :in_progress)
      expect(session.active?).to be true
    end

    it 'returns true for planned status' do
      session = PomodoroSession.create!(user: user, status: :planned)
      expect(session.active?).to be true
    end

    it 'returns false for completed status' do
      session = PomodoroSession.create!(user: user, status: :completed, duration: 1500)
      expect(session.active?).to be false
    end

    it 'returns false for cancelled status' do
      session = PomodoroSession.create!(user: user, status: :cancelled)
      expect(session.active?).to be false
    end
  end
end
