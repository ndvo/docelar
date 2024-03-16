module ApplicationHelper
  def brl(amount)
    number_to_currency(amount, unit: "R$", separator: ',', delimiter: '.')
  end
end
