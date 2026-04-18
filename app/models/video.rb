class Video < ApplicationRecord
  belongs_to :category, class_name: 'VideoCategory', optional: true
  belongs_to :user, optional: true

  has_one_attached :file
  has_many :playlist_items, dependent: :destroy
  has_many :playlists, through: :playlist_items
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings, class_name: 'VideoTag'
  has_many :comments, dependent: :destroy, class_name: 'VideoComment'
  has_many :notes, dependent: :destroy, class_name: 'VideoNote'

  validates :title, presence: true
  validate :file_type_validation, if: -> { file.attached? }

  def file_type_validation
    return unless file.attached?
    allowed_types = %w[video/mp4 video/webm video/ogg video/quicktime video/x-msvideo]
    if file.blob.content_type.present? && !allowed_types.include?(file.blob.content_type)
      errors.add(:file, "must be a video file")
    end
  end

  scope :recent, -> { order(created_at: :desc) }
  scope :watched, -> { where(watched: true) }
  scope :unwatched, -> { where(watched: false) }
  scope :by_category, ->(category_id) { where(video_category_id: category_id) }

  def formatted_duration
    return nil unless duration_seconds
    hours = duration_seconds / 3600
    minutes = (duration_seconds % 3600) / 60
    seconds = duration_seconds % 60
    hours > 0 ? "#{hours}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}" : "#{minutes}:#{seconds.to_s.rjust(2, '0')}"
  end

  def progress_percentage
    return 0 unless duration_seconds && duration_seconds > 0
    ((playback_position.to_f / duration_seconds) * 100).round
  end

  def file_path_or_url
    if file.attached?
      Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true)
    elsif file_path.present?
      file_path
    elsif external_url.present?
      external_url
    end
  end
end