FactoryBot.define do
  factory :medical_appointment do
    association :patient
    appointment_date { DateTime.now + 7.days }
    appointment_type { MedicalAppointment.appointment_types.keys.sample }
    status { MedicalAppointment.statuses.keys.sample }
  end
end
