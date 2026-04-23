class BackfillAppointmentTypeId < ActiveRecord::Migration[8.0]
  def up
    return if column_nil?

    MedicalAppointment.find_each do |appointment|
      type_name = appointment.read_attribute(:appointment_type)
      next if type_name.blank?

      appointment_type = AppointmentType.find_by(name: type_name)
      if appointment_type
        appointment.update_column(:appointment_type_id, appointment_type.id)
      end
    end
  end

  def column_nil?
    !MedicalAppointment.column_names.include?('appointment_type')
  end
end
