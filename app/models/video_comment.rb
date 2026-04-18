class VideoComment < ApplicationRecord
  belongs_to :video
  belongs_to :user
  belongs_to :parent, class_name: 'VideoComment', optional: true
  has_many :replies, class_name: 'VideoComment', foreign_key: 'parent_id', dependent: :destroy

  validates :content, presence: true
end