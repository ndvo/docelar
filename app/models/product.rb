class Product < ApplicationRecord
  has_many :purchases, inverse_of: :product
  validates :name, presence: true
  validates_uniqueness_of :name, scope: %i[brand kind]

  before_destroy :prevent_destruction_with_purchases

  def prevent_destruction_with_purchases
    return unless purchases.exists?

    raise ActiveRecord::RecordNotDestroyed, I18n.t('errors.messages.cannot_destroy_with_purchases')
  end
end
