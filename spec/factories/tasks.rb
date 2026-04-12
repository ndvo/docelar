FactoryBot.define do
  factory :task do
    name { "Sample Task" }
    description { "Task description" }
    is_completed { false }
  end
end
