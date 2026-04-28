class Physician < ApplicationRecord
  belongs_to :person, optional: true
  has_many :medical_appointments

  validates :name, presence: true
  validates :crm, presence: true, uniqueness: { case_sensitive: false }
  validates :person_id, uniqueness: { allow_blank: true }, if: :person_id_changed?

  def display_name
    "#{name} - CRM #{crm}"
  end
end