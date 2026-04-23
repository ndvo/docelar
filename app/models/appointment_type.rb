class AppointmentType < ApplicationRecord
  has_many :medical_appointments

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :active, -> { where(active: true) }
  scope :for_type, ->(type) { where('applicable_types LIKE ?', "%#{type}%") }

  def applicable_types_list
    applicable_types.to_s.split(',')
  end

  def applicable_to?(type)
    applicable_types_list.include?(type.to_s)
  end
end