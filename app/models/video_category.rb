class VideoCategory < ApplicationRecord
  has_many :videos
  has_many :children, class_name: 'VideoCategory', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'VideoCategory', optional: true

  validates :name, presence: true
end