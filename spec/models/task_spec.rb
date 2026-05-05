require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password123') }

  describe 'associations' do
    it { is_expected.to belong_to(:responsible).optional }
    it { is_expected.to belong_to(:task).optional }
    it { is_expected.to belong_to(:project).optional }
    it { is_expected.to belong_to(:recurring_task).class_name('Task').optional }
    it { is_expected.to have_many(:recurring_tasks).class_name('Task').with_foreign_key(:recurring_task_id) }
    it { is_expected.to have_many(:subtasks).class_name('Task').with_foreign_key(:task_id).dependent(:nullify) }
  end

  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:status).in_array(Task::STATUSES.keys) }
    # GTD status is automatically synced from status on create/update
    # so we test the syncing behavior instead of direct validation
  end

  describe 'enums' do
    it 'defines energy_level enum' do
      expect(Task.energy_levels).to eq('high' => 0, 'medium' => 1, 'low' => 2)
    end

    it 'defines priority enum' do
      expect(Task.priorities).to eq(
        'q1_urgent_important' => 0,
        'q2_not_urgent_important' => 1,
        'q3_urgent_not_important' => 2,
        'q4_not_urgent_not_important' => 3
      )
    end

    it 'defines gtd_status enum with all 9 statuses' do
      expect(Task.gtd_statuses).to eq(
        'inbox' => 0,
        'next_action' => 1,
        'scheduled' => 2,
        'waiting_for' => 3,
        'in_progress' => 4,
        'on_hold' => 5,
        'completed' => 6,
        'dropped' => 7,
        'missed' => 8
      )
    end
  end

  describe 'GTD status syncing' do
    context 'when creating a new task' do
      it 'syncs gtd_status from status on create' do
        task = Task.new(status: 'idea', gtd_status: nil)
        task.save!
        expect(task.reload.gtd_status).to eq('inbox')
      end

      it 'maps planned to next_action' do
        task = Task.create!(status: 'planned')
        expect(task.gtd_status).to eq('next_action')
      end

      it 'maps scheduled to scheduled' do
        task = Task.create!(status: 'scheduled')
        expect(task.gtd_status).to eq('scheduled')
      end

      it 'maps waiting to waiting_for' do
        task = Task.create!(status: 'waiting')
        expect(task.gtd_status).to eq('waiting_for')
      end

      it 'maps in_progress to in_progress' do
        task = Task.create!(status: 'in_progress')
        expect(task.gtd_status).to eq('in_progress')
      end

      it 'maps paused to on_hold' do
        task = Task.create!(status: 'paused')
        expect(task.gtd_status).to eq('on_hold')
      end

      it 'maps completed to completed' do
        task = Task.create!(status: 'completed')
        expect(task.gtd_status).to eq('completed')
      end

      it 'maps cancelled to dropped' do
        task = Task.create!(status: 'cancelled')
        expect(task.gtd_status).to eq('dropped')
      end

      it 'maps missed to missed' do
        task = Task.create!(status: 'missed')
        expect(task.gtd_status).to eq('missed')
      end
    end

    context 'when updating status' do
      let(:task) { Task.create!(status: 'idea') }

      it 'syncs gtd_status when status changes' do
        task.update!(status: 'planned')
        expect(task.gtd_status).to eq('next_action')
      end

      it 'does not sync gtd_status when other attributes change' do
        task.update!(name: 'Updated name')
        expect(task.gtd_status).to eq('inbox')
      end
    end

    context 'when gtd_status is already set' do
      it 'syncs gtd_status when status changes even if gtd_status was manually set' do
        task = Task.create!(status: 'idea')
        # Manually update gtd_status to something else
        task.update_column(:gtd_status, 'next_action')
        # Now change status - should sync
        task.update!(status: 'scheduled')
        expect(task.reload.gtd_status).to eq('scheduled')
      end
    end
  end

  describe 'GTD scopes' do
    before do
      Task.create!(status: 'idea')      # inbox
      Task.create!(status: 'planned')   # next_action
      Task.create!(status: 'scheduled') # scheduled
      Task.create!(status: 'waiting')   # waiting_for
      Task.create!(status: 'in_progress') # in_progress
      Task.create!(status: 'paused')    # on_hold
      Task.create!(status: 'completed') # completed
      Task.create!(status: 'cancelled') # dropped
      Task.create!(status: 'missed')    # missed
    end

    describe '.gtd_inbox' do
      it 'returns tasks with gtd_status inbox' do
        expect(Task.gtd_inbox.count).to eq(1)
        expect(Task.gtd_inbox.first.gtd_status).to eq('inbox')
      end
    end

    describe '.gtd_next_actions' do
      it 'returns tasks with gtd_status next_action' do
        expect(Task.gtd_next_actions.count).to eq(1)
        expect(Task.gtd_next_actions.first.gtd_status).to eq('next_action')
      end
    end

    describe '.gtd_waiting_for' do
      it 'returns tasks with gtd_status waiting_for' do
        expect(Task.gtd_waiting_for.count).to eq(1)
        expect(Task.gtd_waiting_for.first.gtd_status).to eq('waiting_for')
      end
    end

    describe '.gtd_on_hold' do
      it 'returns tasks with gtd_status on_hold' do
        expect(Task.gtd_on_hold.count).to eq(1)
        expect(Task.gtd_on_hold.first.gtd_status).to eq('on_hold')
      end
    end

    describe '.gtd_active' do
      it 'returns tasks not in end statuses' do
        active_tasks = Task.gtd_active
        expect(active_tasks.count).to eq(6) # inbox, next_action, scheduled, waiting_for, in_progress, on_hold
        active_tasks.each do |task|
          expect(Task::GTD_END_STATUSES).not_to include(task.gtd_status)
        end
      end
    end
  end

  describe 'helper methods' do
    describe '#completed?' do
      it 'returns true for completed status using gtd_status' do
        task = Task.create!(status: 'completed')
        expect(task.completed?).to be true
      end

      it 'returns false for non-completed status' do
        task = Task.create!(status: 'idea')
        expect(task.completed?).to be false
      end
    end

    describe '#missed?' do
      it 'returns true for missed status using gtd_status' do
        task = Task.create!(status: 'missed')
        expect(task.missed?).to be true
      end

      it 'returns false for non-missed status' do
        task = Task.create!(status: 'idea')
        expect(task.missed?).to be false
      end
    end

    describe '#pending?' do
      it 'returns true for pending statuses using gtd_status' do
        task = Task.create!(status: 'idea')
        expect(task.pending?).to be true
      end

      it 'returns false for end statuses' do
        task = Task.create!(status: 'completed')
        expect(task.pending?).to be false
      end
    end

    describe '#end_state?' do
      it 'returns true for end states using gtd_status' do
        task = Task.create!(status: 'completed')
        expect(task.end_state?).to be true
      end

      it 'returns false for non-end states' do
        task = Task.create!(status: 'idea')
        expect(task.end_state?).to be false
      end
    end

    describe '#gtd_completed?' do
      it 'returns true when gtd_status is completed' do
        task = Task.create!(status: 'completed')
        expect(task.gtd_completed?).to be true
      end
    end

    describe '#gtd_missed?' do
      it 'returns true when gtd_status is missed' do
        task = Task.create!(status: 'missed')
        expect(task.gtd_missed?).to be true
      end
    end

    describe '#gtd_active?' do
      it 'returns true for active gtd statuses' do
        task = Task.create!(status: 'idea')
        expect(task.gtd_active?).to be true
      end

      it 'returns false for end gtd statuses' do
        task = Task.create!(status: 'completed')
        expect(task.gtd_active?).to be false
      end
    end
  end

  describe 'new fields' do
    it 'can set context' do
      task = Task.create!(status: 'idea', context: '@computer')
      expect(task.context).to eq('@computer')
    end

    it 'can set energy_level' do
      task = Task.create!(status: 'idea', energy_level: 'high')
      expect(task.energy_level).to eq('high')
    end

    it 'can set priority' do
      task = Task.create!(status: 'idea', priority: 'q1_urgent_important')
      expect(task.priority).to eq('q1_urgent_important')
    end

    it 'can associate with project' do
      project = Project.create!(name: 'Test Project', user: user)
      task = Task.create!(status: 'idea', project: project)
      expect(task.project).to eq(project)
    end
  end
end
