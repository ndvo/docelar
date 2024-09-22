class Pharmacotherapy < ApplicationRecord
  belongs_to :treatment
  belongs_to :medication
end
