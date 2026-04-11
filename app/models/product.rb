class Product < ApplicationRecord
  has_many :purchases, inverse_of: :product
  validates :name, presence: true
  validates_uniqueness_of :name, scope: %i[brand kind]

  before_destroy :prevent_destruction_with_purchases

  def prevent_destruction_with_purchases
    throw(:abort) if purchases.exists?
  end

  def average_price_in_period(days)
    cutoff = days.days.ago
    result = purchases.where('purchase_at >= ?', cutoff).pick(Arel.sql('AVG(price)'))
    result&.to_f
  end

  def average_price_last_month
    average_price_in_period(30)
  end

  def average_price_last_year
    average_price_in_period(365)
  end

  def average_price_last_5_years
    average_price_in_period(365 * 5)
  end
end
