class Treatment < ApplicationRecord
  belongs_to :patient
  has_many :pharmacotherapies

  accepts_nested_attributes_for :pharmacotherapies, allow_destroy: true, reject_if: :all_blank

end
