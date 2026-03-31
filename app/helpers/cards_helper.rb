module CardsHelper
  def card_brand_icon(brand)
    return '💳' unless brand.present?
    
    case brand.downcase
    when 'visa'
      '💳 Visa'
    when 'mastercard'
      '💳 Mastercard'
    when 'american express'
      '💳 Amex'
    when 'hipercard'
      '💳 Hipercard'
    when 'elo'
      '💳 Elo'
    else
      '💳'
    end
  end
end
