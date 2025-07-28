class Tag < ApplicationRecord
  has_many :taggeds
  has_many :tagged_photos
  has_many :photos, through: :tagged_photos

  validates :name, uniqueness: true
end
