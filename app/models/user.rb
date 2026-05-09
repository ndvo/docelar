class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :greeting_cards, dependent: :destroy
  has_many :letter_backgrounds, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :task_logs, dependent: :destroy
  has_many :pomodoro_sessions, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true
  validates :daily_pomodoro_goal, numericality: { greater_than_or_equal_to: 1, allow_nil: false }
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
