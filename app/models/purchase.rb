class Purchase < ApplicationRecord
  belongs_to :product
  has_many :payments

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
end
