FactoryBot.define do
  factory :project do
    association :user
    name { "My Project" }
    description { "Project description" }
    outcome { "Expected outcome" }
    project_type { "outcome_based" }
    category { "work" }
    status { "active" }
    next_review_date { Date.today + 30.days }
  end
end
