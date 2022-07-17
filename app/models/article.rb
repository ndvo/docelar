class Article < ApplicationRecord
  has_many :comments

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { minimum: 10 }
end
