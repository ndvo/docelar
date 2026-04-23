class Physician < ApplicationRecord
  belongs_to :person, optional: true
  has_many :medical_appointments

  validates :name, presence: true
  validates :crm, presence: true, uniqueness: { case_sensitive: false }

  def display_name
    "#{name} - CRM #{crm}"
  end
end