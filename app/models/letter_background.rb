class LetterBackground < ApplicationRecord
  belongs_to :user
  belongs_to :photo, optional: true
  has_one_attached :image

  enum :source_type, {
    uploaded: 0,
    gallery: 1
  }, prefix: true

  validates :name, presence: true
  validates :source_type, presence: true

  scope :active, -> { where(active: true) }
  scope :for_user, ->(user) { where(user: user) }

  def image_url
    if photo.present?
      Rails.application.routes.url_helpers.rails_blob_url(photo.file) if photo.file.attached?
    elsif image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(image)
    end
  end
end