class Font < ApplicationRecord
  has_one_attached :file

  validates :name, presence: true
  validate :font_file_attached

  scope :active, -> { where(active: true) }

  OCCASION_OPTIONS = [
    "birthday",
    "christmas",
    "anniversary",
    "wedding",
    "baby",
    "graduation",
    "thank_you",
    "get_well",
    "congratulations",
    "other"
  ].freeze

  def font_file_attached
    errors.add(:file, "must be attached") unless file.attached?
  end

  def font_path
    return nil unless file.attached?

    blob = file.blob
    ActiveStorage::Blob.service.path_for(blob.key)
  rescue StandardError
    nil
  end
end