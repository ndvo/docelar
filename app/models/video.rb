class Video < ApplicationRecord
  belongs_to :category, class_name: 'VideoCategory', optional: true
  belongs_to :user, optional: true

  has_one_attached :file
  has_one_attached :enhanced_file
  has_many :playlist_items, dependent: :destroy
  has_many :playlists, through: :playlist_items
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings, class_name: 'VideoTag'
  has_many :comments, dependent: :destroy, class_name: 'VideoComment'
  has_many :notes, dependent: :destroy, class_name: 'VideoNote'

  validates :title, presence: true
  validate :file_type_validation, if: -> { file.attached? }

  enum :enhance_audio_status, {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }, prefix: :audio

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
  scope :needs_audio_processing, -> { where(enhance_audio: true).where(enhance_audio_status: :pending) }

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
    if enhanced_file.attached? && audio_completed?
      Rails.application.routes.url_helpers.rails_blob_url(enhanced_file, only_path: true)
    elsif file.attached?
      Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true)
    elsif file_path.present?
      file_path
    elsif external_url.present?
      external_url
    end
  end

  def current_file_url
    file_path_or_url
  end

  def thumbnail_url
    if poster_url.present?
      poster_url
    elsif file.attached? && file.previewable?
      Rails.application.routes.url_helpers.preview_path(file, only_path: true)
    end
  end

  def has_thumbnail?
    poster_url.present? || (file.attached? && file.previewable?)
  end

  def queue_audio_enhancement!
    update!(enhance_audio_status: :pending) if enhance_audio && !audio_completed?
  end
end