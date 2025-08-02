class Responsible < ApplicationRecord
  belongs_to :person, optional: false
  has_many :tasks

  before_validation :fill_name

  def fill_name
    self.name = name.presence || person.name
  end

  validates :person, uniqueness: true

  def open_tasks_count
    Task.where(responsible: self).pending.count
  end

  def closed_tasks_count
    Task.where(responsible: self).completed.count
  end
end
