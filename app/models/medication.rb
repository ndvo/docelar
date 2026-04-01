class Medication < ApplicationRecord
  has_many :medication_products
  has_many :pharmacotherapies

  validates :name, presence: true, uniqueness: { case_insensitive: true }
end
