FactoryBot.define do
  factory :medical_appointment do
    association :patient
    appointment_date { DateTime.now + 7.days }
    appointment_type { MedicalAppointment.appointment_types.keys.sample }
    status { MedicalAppointment.statuses.keys.sample }

    trait :scheduled do
      status { :scheduled }
    end

    trait :completed do
      status { :completed }
    end

    trait :cancelled do
      status { :cancelled }
    end

    trait :checkup do
      appointment_type { :checkup }
    end

    trait :follow_up do
      appointment_type { :follow_up }
    end
  end
end
