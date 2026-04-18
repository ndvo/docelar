class Video < ApplicationRecord
  belongs_to :category, class_name: 'VideoCategory', optional: true
  belongs_to :user, optional: true

  has_many :playlist_items, dependent: :destroy
  has_many :playlists, through: :playlist_items
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings, class_name: 'VideoTag'
  has_many :comments, dependent: :destroy, class_name: 'VideoComment'
  has_many :notes, dependent: :destroy, class_name: 'VideoNote'

  validates :title, presence: true

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
end