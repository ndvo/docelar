class Patient < ApplicationRecord
  belongs_to :individual, polymorphic: true
end
