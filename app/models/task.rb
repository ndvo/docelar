class Task < ApplicationRecord
  belongs_to :responsible, optional: true
  belongs_to :task, optional: true

  scope :completed, -> { where is_completed: true }
  scope :pending, -> { where is_completed: false }
  scope :in_project, ->(project) { where task: project }

  def self.task_by_status(status)
  end
end
