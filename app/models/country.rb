class Country < ApplicationRecord
  has_many :nationalies
  has_many :people, through: :nationalities

  validates_presence_of :name
end
