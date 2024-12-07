class Task < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :task, optional: true

  scope :completed, -> () { where is_completed: true }
  scope :pending, ->() { where is_completed: false }
end
