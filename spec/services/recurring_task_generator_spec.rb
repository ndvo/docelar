require 'rails_helper'

RSpec.describe RecurringTaskGenerator do
  describe '.generate_next' do
    context 'with daily recurrence' do
      let!(:task) { FactoryBot.create(:task, :daily, name: 'Daily Task', due_date: Date.new(2026, 4, 30)) }

      it 'creates a new task with due date one day later' do
        expect { described_class.generate_next(task) }.to change(Task, :count).by(1)

        new_task = Task.last
        expect(new_task.due_date).to eq(Date.new(2026, 5, 1))
        expect(new_task.name).to eq('Daily Task')
        expect(new_task.recurrence_rule).to eq('daily')
        expect(new_task.recurring_task).to eq(task)
      end
    end

    context 'with weekly recurrence' do
      let!(:task) { FactoryBot.create(:task, :weekly, name: 'Weekly Task', due_date: Date.new(2026, 4, 30)) }

      it 'creates a new task with due date one week later' do
        described_class.generate_next(task)

        new_task = Task.last
        expect(new_task.due_date).to eq(Date.new(2026, 5, 7))
        expect(new_task.recurrence_rule).to eq('weekly')
      end
    end

    context 'with monthly recurrence' do
      let!(:task) { FactoryBot.create(:task, :monthly, name: 'Monthly Task', due_date: Date.new(2026, 4, 30)) }

      it 'creates a new task with due date one month later' do
        described_class.generate_next(task)

        new_task = Task.last
        expect(new_task.due_date).to eq(Date.new(2026, 5, 30))
        expect(new_task.recurrence_rule).to eq('monthly')
      end
    end

    context 'without recurrence rule' do
      let!(:task) { FactoryBot.create(:task, name: 'One-time Task') }

      it 'does not create a new task' do
        expect { described_class.generate_next(task) }.not_to change(Task, :count)
      end
    end

    context 'with recurrence but no due date' do
      let!(:task) { FactoryBot.create(:task, recurrence_rule: 'daily', due_date: nil) }

      it 'does not create a new task' do
        expect { described_class.generate_next(task) }.not_to change(Task, :count)
      end
    end

    context 'for a generated task (has recurring_task_id)' do
      let!(:parent_task) { FactoryBot.create(:task, :daily, due_date: Date.new(2026, 4, 30)) }
      let!(:child_task) { FactoryBot.create(:task, :daily, due_date: Date.new(2026, 5, 1), recurring_task: parent_task) }

      it 'does not create another task' do
        expect { described_class.generate_next(child_task) }.not_to change(Task, :count)
      end
    end
  end
end
