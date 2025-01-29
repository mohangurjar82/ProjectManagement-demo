FactoryBot.define do
  factory :task do
    project
    created_by { create(:user) }
    name { "Test Task" }
    description { "Task Description" }
    start_time { Date.today }
    duration { 10 }
    uuid { SecureRandom.uuid }
  end
end