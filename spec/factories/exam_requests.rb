FactoryBot.define do
  factory :exam_request do
    association :patient
    exam_name { "Ressonância Magnética" }
    requested_date { Date.today }
    status { ExamRequest.statuses.keys.sample }
  end
end
