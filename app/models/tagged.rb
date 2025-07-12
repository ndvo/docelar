class Tagged < ApplicationRecord
  belongs_to :tagged, polymorphic: true
  belongs_to :tag
end
