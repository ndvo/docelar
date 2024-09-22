class Medication < ApplicationRecord
  has_many :medication_products
  has_many :pharmacotherapies

  validates :name, uniqueness: true
end
