class Dog < ApplicationRecord
  has_one_attached :image
  after_save :sync_patient

  def sync_patient
    Patient.find_or_create_by(individual_id: id, individual_type: 'Dog')
  end

  def age
    return nil unless birth
    today = Date.today
    age = today.year - birth.year
    age -= 1 if today.month < birth.month || (today.month == birth.month && today.day < birth.day)
    age
  end
end
