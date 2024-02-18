class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :card, optional: true
  has_many :payments, dependent: :destroy

  scope :month, ->(m) { where('purchase_at >= ? and purchase_at <= ?', *(date_begin_end m)) }

  accepts_nested_attributes_for :payments,
                                reject_if: :all_blank,
                                allow_destroy: true

  def qty_installments
    [payments.count, 1].max
  end

  def qty_installments=(qty)
    qty = [qty&.to_i, 1].max
    return if price.blank?

    installment_value = (price / qty).round(2)
    first_value = price - (installment_value * (qty - 1))

    self.payments = (0...qty).map do |idx|
      installment = self.payments[idx].presence
      installment_data = {
        due_amount: (idx == 0 ? first_value : installment_value),
        due_at: installment_due_date(idx)
      }
      if installment.present?
        installment.assign_attributes(installment_data)
        installment
      else
        self.payments.build(installment_data)
      end
    end
  end

  def installment_due_date(idx)
    if card.present?
      card.next_due_date_from(purchase_at) + idx.months
    else
      (purchase_at || Date.today) + idx.months
    end
  end

  validates :product, presence: true
  validates_associated :payments, :product

  private

  def self.date_begin_end(a_date)
    [a_date.at_beginning_of_month.to_s, a_date.at_end_of_month.to_s]
  end
end
