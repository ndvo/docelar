FactoryBot.define do
  factory :medical_exam do
    association :patient
    exam_date { Date.today + 7.days }
    exam_type { MedicalExam.exam_types.keys.sample }
    name { "Exame de #{MedicalExam.exam_types.keys.sample}" }
    laboratory { "Laboratório Central" }
    status { MedicalExam.statuses.keys.sample }
  end
end
