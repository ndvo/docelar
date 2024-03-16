class Payment < ApplicationRecord
  belongs_to :purchase

  scope :due_at_month, ->(date) { at_month 'due_at', date }
  scope :paid_at_month, ->(date) { at_month 'paid_at', date }
  scope :late, -> { past_month('due_at', Date.today).where(paid_at: nil) }

  scope :at_month, (lambda do |field, date|
    acceptable_fields = %w[paid_at due_at]
    return where('True = False') unless acceptable_fields.include? field

    month = "#{date.year}-#{date.month.to_s.rjust(2, '0')}"
    where("strftime('%Y-%m', #{field}) = ?", month)
  end)

  scope :past_month, (lambda do |field, date|
    acceptable_fields = %w[paid_at due_at]
    return where('True = False') unless acceptable_fields.include? field

    month = "#{date.year}-#{date.month.to_s.rjust(2, '0')}"
    where("strftime('%Y-%m', #{field}) < ?", month)
  end)
end
