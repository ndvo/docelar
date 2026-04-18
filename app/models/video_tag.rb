class VideoTag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :videos, through: :taggings

  validates :name, presence: true
end

class VideoTagging < ApplicationRecord
  belongs_to :video
  belongs_to :tag, class_name: 'VideoTag'
end