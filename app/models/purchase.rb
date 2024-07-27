class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :card, optional: true
  has_many :payments, dependent: :destroy

  include Datable

  scope :month, ->(m) { at_month m, 'purchase_at' }

  accepts_nested_attributes_for :payments,
                                reject_if: :all_blank,
                                allow_destroy: true

  before_save :adjust_payments

  validates :product, presence: true
  validates_associated :payments, :product

  # store in memory during build to adjust payments after_initialize
  def number_of_installments=(qty)
    write_attribute(:number_of_installments, [qty&.to_i, 1].max)
  end

  def number_of_installments
    [payments.count, 1].max
  end

  def number_of_installments
    raw_value = read_attribute(:number_of_installments)
    return payments.count if raw_value.nil?

    raw_value
  end

  def adjust_payments
    installments = number_of_installments
    return if price.blank?

    installment_value = (value_total / installments).round(2)
    first_value = value_total - (installment_value * (installments - 1))

    self.payments = (0...installments).map do |idx|
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
      card_installment_due_date(idx)
    else
      (purchase_at || Date.today) + idx.months
    end
  end

  def card_installment_due_date(idx)
    next_due = card.next_due_date_from(purchase_at)
    next_due ? card.next_due_date_from(purchase_at) + idx.months : nil
  end

  def value_total
    price * quantity
  end
end
