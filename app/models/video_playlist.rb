class VideoPlaylist < ApplicationRecord
  has_many :items, dependent: :destroy, class_name: 'VideoPlaylistItem'
  has_many :videos, through: :items
  belongs_to :user

  validates :name, presence: true
end

class VideoPlaylistItem < ApplicationRecord
  belongs_to :playlist, class_name: 'VideoPlaylist'
  belongs_to :video
end