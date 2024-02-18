class Card < ApplicationRecord
  def display_name
    "#{brand} - #{name} - #{masked_number}"
  end

  def masked_number = "**** **** **** #{number.last(4)}"

  def next_due_date_from(date)
    due_date = Date.new(date.year, date.month, due_day)

    due_date += 1.month if date.day >= invoice_day;
    due_date += 1.month if invoice_day > due_day;
    due_date
  end
end
