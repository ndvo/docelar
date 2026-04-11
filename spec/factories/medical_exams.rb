FactoryBot.define do
  factory :medical_exam do
    association :patient
    exam_date { Date.today + 7.days }
    exam_type { MedicalExam.exam_types.keys.sample }
    name { "Exame de #{MedicalExam.exam_types.keys.sample}" }
    laboratory { "Laboratório Central" }
    status { MedicalExam.statuses.keys.sample }

    trait :scheduled do
      status { :scheduled }
    end

    trait :completed do
      status { :completed }
    end

    trait :results_received do
      status { :results_received }
    end

    trait :blood_test do
      exam_type { :blood_test }
    end

    trait :imaging do
      exam_type { :imaging }
    end
  end
end
