class VideoNote < ApplicationRecord
  belongs_to :video
  belongs_to :user, optional: true

  validates :content, presence: true
end