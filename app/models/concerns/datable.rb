module Datable
  extend ActiveSupport::Concern

  included do
    scope :at_month, (lambda do |date, field|
      month = "#{date.year}-#{date.month.to_s.rjust(2, '0')}"
      where("strftime('%Y-%m', #{field}) = ?", month)
    end)

    scope :past_month, (lambda do |date, field|
      month = "#{date.year}-#{date.month.to_s.rjust(2, '0')}"
      where("strftime('%Y-%m', #{field}) < ?", month)
    end)

    scope :this_month, (lambda do |field|
      at_month(Date.today, field)
    end)
  end
end
