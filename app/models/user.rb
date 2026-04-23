class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :greeting_cards, dependent: :destroy
  has_many :letter_backgrounds, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
