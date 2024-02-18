class Card < ApplicationRecord
  def display_name
    "#{brand} - #{name} - #{masked_number}"
  end

  def masked_number = "**** **** **** #{number.last(4)}"
end
