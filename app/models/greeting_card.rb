class GreetingCard < ApplicationRecord
  belongs_to :person, optional: true
  belongs_to :user
  belongs_to :letter_background, optional: true

  has_one_attached :preview_image

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

  after_save :generate_preview_image, if: :should_generate_preview?

  def regenerate_preview!
    generate_preview_image
  end

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

  def regenerate_preview!
    generate_preview_image
  end

  private

  def should_generate_preview?
    saved_change_to_title? || saved_change_to_message? || saved_change_to_letter_background_id? || saved_change_to_font_family? || preview_image.blank?
  end

  def generate_preview_image
    image = GreetingCardImageService.generate(self)
    
    buffer = StringIO.new
    image.write(buffer)
    buffer.rewind
    
    preview_image.attach(io: buffer, filename: "preview.png", content_type: "image/png")
  rescue => e
    Rails.logger.error "Failed to generate preview: #{e.message}"
    Rails.logger.error e.backtrace.first(5).join("\n")
  end
end