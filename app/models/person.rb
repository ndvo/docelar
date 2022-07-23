class Person < ApplicationRecord
  has_many :nationalities
  has_many :countries, through: :nationalities

  accepts_nested_attributes_for :nationalities
end
