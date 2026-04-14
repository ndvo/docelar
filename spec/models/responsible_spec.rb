require 'rails_helper'

RSpec.describe Responsible, type: :model do
  describe 'associations' do
    it { should have_many(:tasks) }
  end

  describe '#fill_name' do
    it 'fills name from person if not provided' do
      person = Person.create!(name: 'John Doe')
      responsible = Responsible.create!(person: person)
      responsible.reload
      expect(responsible.name).to eq('John Doe')
    end
  end

  describe '#open_tasks_count' do
    it 'returns count of pending tasks' do
      person = Person.create!(name: 'John Doe')
      responsible = Responsible.create!(person: person)
      Task.create!(responsible: responsible, is_completed: false)
      Task.create!(responsible: responsible, is_completed: true)

      expect(responsible.open_tasks_count).to eq(1)
    end
  end

  describe '#closed_tasks_count' do
    it 'returns count of completed tasks' do
      person = Person.create!(name: 'John Doe')
      responsible = Responsible.create!(person: person)
      Task.create!(responsible: responsible, is_completed: false)
      Task.create!(responsible: responsible, is_completed: true)

      expect(responsible.closed_tasks_count).to eq(1)
    end
  end
end