require 'rails_helper'

RSpec.describe 'Tasks Management', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'Task list' do
    scenario 'shows all tasks' do
      task = create(:task, name: 'Buy groceries')

      visit tasks_path
      expect(page).to have_content('Buy groceries')
    end

    scenario 'filters by completion status' do
      create(:task, name: 'Pending Task', is_completed: false)
      create(:task, name: 'Completed Task', is_completed: true)

      visit tasks_path(completed: 'false')
      expect(page).to have_content('Pending Task')
    end
  end

  describe 'Create task' do
    scenario 'creates a new task' do
      visit new_task_path
      fill_in 'task[name]', with: 'New Task'
      fill_in 'task[description]', with: 'Task description'
      click_button 'Criar Task'

      expect(page).to have_current_path(/\/tasks\/\d+/)
      expect(page).to have_content('New Task')
    end

    scenario 'creates task without required fields' do
      visit new_task_path
      click_button 'Criar Task'

      expect(page).to have_current_path(/\/tasks\/\d+/)
    end
  end

  describe 'View task' do
    scenario 'shows task details' do
      task = create(:task, name: 'Detailed Task', description: 'Full description')

      visit task_path(task)
      expect(page).to have_content('Detailed Task')
    end
  end

  describe 'Edit task' do
    scenario 'updates task information' do
      task = create(:task, name: 'Old Name')

      visit edit_task_path(task)
      fill_in 'task[name]', with: 'Updated Task'
      click_button 'Atualizar Task'

      expect(page).to have_content('Updated Task')
    end
  end
end
