class Purchase < ApplicationRecord
  belongs_to :product
  has_many :payments, dependent: :destroy

  scope :month, ->(m) { where('purchase_at >= ? and purchase_at <= ?', *(date_begin_end m)) }

  accepts_nested_attributes_for :payments,
                                reject_if: :all_blank,
                                allow_destroy: true

  def qty_installments
    payments.count
  end

  def qty_installments=(qty)
    qty = [qty&.to_i, 1].max
    return if prise.blank?
    installment_value = (price / qty).round(2)

    first_value = price - (installment_value * (qty - 1))

    self.payments = (0...qty).map do |idx|
      if self.payments[idx]&.present?
        self.payments[idx].due_amount = idx == 0 ? first_value : installment_value
        self.payments[idx]
      else
        self.payments.build(
          due_amount: idx == 0 ? first_value : installment_value,
          due_at: created_at + idx.months
        )
      end
    end
  end

  validates :product, presence: true
  validates_associated :payments, :product

  private

  def self.date_begin_end(a_date)
    [a_date.at_beginning_of_month.to_s, a_date.at_end_of_month.to_s]
  end
end
