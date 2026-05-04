require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password123') }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:tasks).dependent(:nullify) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:user) }
  end

  describe 'enums' do
    it 'defines project_type enum' do
      expect(Project.project_types).to eq('outcome_based' => 0, 'ongoing' => 1)
    end

    it 'defines status enum' do
      expect(Project.statuses).to eq('active' => 0, 'on_hold' => 1, 'completed' => 2, 'someday' => 3)
    end
  end

  describe 'scopes' do
    let!(:active_project) { Project.create!(name: 'Active Project', user: user, status: 'active') }
    let!(:on_hold_project) { Project.create!(name: 'On Hold Project', user: user, status: 'on_hold') }
    let!(:completed_project) { Project.create!(name: 'Completed Project', user: user, status: 'completed') }
    let!(:someday_project) { Project.create!(name: 'Someday Project', user: user, status: 'someday') }

    describe '.active' do
      it 'returns only active projects' do
        expect(Project.active).to include(active_project)
        expect(Project.active).not_to include(on_hold_project, completed_project, someday_project)
      end
    end

    describe '.on_hold' do
      it 'returns only on_hold projects' do
        expect(Project.on_hold).to include(on_hold_project)
      end
    end

    describe '.completed' do
      it 'returns only completed projects' do
        expect(Project.completed).to include(completed_project)
      end
    end

    describe '.someday' do
      it 'returns only someday projects' do
        expect(Project.someday).to include(someday_project)
      end
    end
  end

  describe 'tasks association' do
    let(:project) { Project.create!(name: 'Test Project', user: user) }
    let(:task1) { Task.create!(status: 'idea', project: project) }
    let(:task2) { Task.create!(status: 'planned', project: project) }

    it 'has many tasks' do
      expect(project.tasks).to include(task1, task2)
    end

    it 'nullifies tasks when project is destroyed' do
      task1
      expect { project.destroy }.to change { task1.reload.project }.from(project).to(nil)
    end
  end

  describe 'next_review_date validation' do
    it 'is valid without next_review_date' do
      project = Project.new(name: 'Test Project', user: user, next_review_date: nil)
      expect(project).to be_valid
    end

    it 'is valid with future next_review_date' do
      project = Project.new(name: 'Test Project', user: user, next_review_date: 1.week.from_now)
      expect(project).to be_valid
    end

    it 'is valid with today as next_review_date' do
      project = Project.new(name: 'Test Project', user: user, next_review_date: Date.today)
      expect(project).to be_valid
    end
  end

  describe '#overdue_for_review?' do
    it 'returns false when next_review_date is nil' do
      project = Project.create!(name: 'Test Project', user: user, next_review_date: nil)
      expect(project.overdue_for_review?).to be false
    end

    it 'returns false when next_review_date is in the future' do
      project = Project.create!(name: 'Test Project', user: user, next_review_date: 1.week.from_now)
      expect(project.overdue_for_review?).to be false
    end

    it 'returns true when next_review_date is in the past' do
      project = Project.create!(name: 'Test Project', user: user)
      project.update_column(:next_review_date, 1.week.ago.to_date)
      expect(project.reload.overdue_for_review?).to be true
    end

    it 'returns false when next_review_date is today' do
      project = Project.create!(name: 'Test Project', user: user, next_review_date: Date.today)
      expect(project.overdue_for_review?).to be false
    end
  end
end
