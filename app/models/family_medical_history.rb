class FamilyMedicalHistory < ApplicationRecord
  belongs_to :patient

  enum :relation, {
    mother: 'mother',
    father: 'father',
    sibling: 'sibling',
    grandparent: 'grandparent',
    other: 'other'
  }

  validates :relation, presence: true
  validates :condition_name, presence: true
  validates :diagnosed_relative_date, presence: true

  scope :by_relation, ->(rel) { where(relation: rel) }
end
