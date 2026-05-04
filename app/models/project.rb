class Project < ApplicationRecord
  belongs_to :user

  enum :project_type, {
    outcome_based: 0,
    ongoing: 1
  }, prefix: true

  enum :status, {
    active: 0,
    on_hold: 1,
    completed: 2,
    someday: 3
  }, prefix: true

  has_many :tasks, dependent: :nullify

  validates :name, presence: true
  validates :user, presence: true
  validate :next_review_date_cannot_be_in_the_past, if: :next_review_date_changed?

  scope :active, -> { where(status: :active) }
  scope :on_hold, -> { where(status: :on_hold) }
  scope :completed, -> { where(status: :completed) }
  scope :someday, -> { where(status: :someday) }

  # Check if project is overdue for review
  def overdue_for_review?
    return false if next_review_date.nil?
    next_review_date < Date.today
  end

  private

  def next_review_date_cannot_be_in_the_past
    return if next_review_date.nil?
    if next_review_date < Date.today
      errors.add(:next_review_date, 'não pode ser no passado')
    end
  end
end
