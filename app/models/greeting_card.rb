class GreetingCard < ApplicationRecord
  belongs_to :person, optional: true
  belongs_to :user
  belongs_to :letter_background, optional: true

  enum :card_type, {
    birthday: 0,
    christmas: 1,
    anniversary: 2,
    wedding: 3,
    baby: 4,
    graduation: 5,
    thank_you: 6,
    get_well: 7,
    congratulations: 8,
    other: 9
  }

  validates :title, presence: true
  validates :card_type, presence: true

  scope :upcoming, -> { where('occasion_date >= ?', Date.today).order(occasion_date: :asc) }
  scope :pending, -> { where(sent: false).order(occasion_date: :asc) }

  def recipient_name
    person&.name || 'Unknown'
  end

  def occasion_date_display
    return unless occasion_date

    if occasion_date.month == 2 && occasion_date.day == 29
      date = Date.new(Date.today.year, 2, 28)
    else
      date = Date.new(Date.today.year, occasion_date.month, occasion_date.day)
    end
    date
  end

  def days_until_occasion
    return unless occasion_date

    target = occasion_date_display
    days = (target - Date.today).to_i
    days < 0 ? days + 365 : days
  end

  def mark_as_sent
    update(sent: true, sent_at: Time.current)
  end
end