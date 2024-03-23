class Payment < ApplicationRecord
  belongs_to :purchase

  include Datable

  scope :due_at_month, ->(date) { at_month date, 'due_at' }
  scope :paid_at_month, ->(date) { at_month date, 'paid_at' }
  scope :late, -> { past_month(Date.today, 'due_at').where(paid_at: nil) }
end
