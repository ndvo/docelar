class Payment < ApplicationRecord
  belongs_to :purchase

  include Datable

  scope :due_at_month, ->(date) { at_month date, 'due_at' }
  scope :due_this_month, ->() { this_month 'due_at' }

  scope :paid_at_month, ->(date) { at_month date, 'paid_at' }
  scope :paid_this_month, ->() { this_month 'paid_at' }

  scope :late, -> { pending.past_month(Date.today, 'due_at') }

  scope :pending, -> { where(paid_at: nil) }
  scope :paid, -> { where.not(paid_at: nil) }

  has_one :card, through: :purchase, inverse_of: :payments

  def pay(date: Time.now, amount: due_amount)
    update(paid_at: date, paid_amount: amount)
  end
end
