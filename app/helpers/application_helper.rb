module ApplicationHelper
  def brl(amount)
    number_to_currency(amount, unit: "R$", separator: ',', delimiter: '.')
  end

  def br_date(day)
    day&.strftime("%d/%m/%Y")
  end

  def google_photos_configured?
    ENV["GOOGLE_CLIENT_ID"].present? && ENV["GOOGLE_CLIENT_SECRET"].present?
  end
end
