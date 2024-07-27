class Card < ApplicationRecord
  has_many :purchases
  has_many :payments, through: :purchases, inverse_of: :card

  def display_name
    "#{brand} - #{name} - #{masked_number}"
  end

  def masked_number = "**** **** **** #{number.last(4)}"

  def next_due_date_from(date)
    return nil unless invoice_day.present? && due_day.present?

    due_date = Date.new(date.year, date.month, due_day)

    due_date += 1.month if date.day >= invoice_day;
    due_date += 1.month if invoice_day > due_day;
    due_date
  end

  def pay_current_month
    to_pay = payments.pending.due_this_month
    to_pay.each &:pay
    to_pay
  end
end
