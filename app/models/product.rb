class Product < ApplicationRecord
  has_many :purchases, inverse_of: :product
  validates :name, presence: true
  validates_uniqueness_of :name, scope: %i[brand kind]
end
