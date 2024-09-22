class Dog < ApplicationRecord
  after_save :sync_patient

  def sync_patient
    Patient.find_or_create_by(individual_id: id, individual_type: 'Dog')
  end
end
