class Purchase < ApplicationRecord
  belongs_to :product
  has_many :payments

  scope :month, ->(m) { where('purchase_at >= ? and purchase_at <= ?', *(date_begin_end m)) }

  accepts_nested_attributes_for :payments,
                                reject_if: :all_blank,
                                allow_destroy: true

  def qty_installments
    @target_qty || payments.count
  end

  def qty_installments=(value)
    @target_qty = value
  end

  accepts_nested_attributes_for :product

  validates :product, presence: true
  validates_associated :payments, :product

  private

  def self.date_begin_end(a_date)
    [a_date.at_beginning_of_month.to_s, a_date.at_end_of_month.to_s]
  end
end
