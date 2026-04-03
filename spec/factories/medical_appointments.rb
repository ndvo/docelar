FactoryBot.define do
  factory :medical_appointment do
    association :patient
    appointment_date { DateTime.now + 7.days }
    appointment_type { MedicalAppointment.appointment_types.keys.first }
    status { MedicalAppointment.statuses.keys.first }
  end
end
