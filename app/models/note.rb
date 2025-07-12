class Note < ApplicationRecord
  has_many :taggeds
  has_many :tags, through: :taggeds
end
