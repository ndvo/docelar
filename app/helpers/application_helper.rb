module ApplicationHelper
  def brl(amount)
    number_to_currency(amount, unit: "R$", separator: ',', delimiter: '.')
  end

  def br_date(day)
    day&.strftime("%d/%m/%Y")
  end
end
