module PaymentsHelper
  def product_short_description(p)
    return p.purchase.product.name if p.purchase.payments.count === 1
    "#{p.purchase.product.name} (#{p.installment_number}/#{p.purchase.payments.count})"
  end
end
