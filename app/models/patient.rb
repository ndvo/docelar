class Patient < ApplicationRecord
  belongs_to :individual, polymorphic: true
  has_many :treatments

  validates :individual_id, uniqueness: { scope: :individual_type }
end
