class Nationality < ApplicationRecord
  belongs_to :person
  belongs_to :country

  validates_presence_of :person
  validates_presence_of :country

  enum :how, {
    jusSanguini: 'jus sanguini',
    jusSoli: 'jus soli',
    naturalization: 'naturalization'
  }
end
