class Patient < ApplicationRecord
  belongs_to :individual, polymorphic: true

  validates :individual_id, uniqueness: { scope: :individual_type }
end
