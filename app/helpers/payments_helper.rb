module PaymentsHelper
  def product_short_description(p) = "#{p.purchase.product.name} (#{p.purchase.purchase_at.strftime("%d/%m/%Y")})"
end
