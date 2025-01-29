FactoryBot.define do
  factory :project do
    name { "Test Project" }
    start_date { Date.today }
    duration_day { 10 }
    duration_timeframe { "Days" }
    uuid { SecureRandom.uuid }
   
    transient do
      users { [] } # Allows passing users to associate with the project
      assigned_by { nil } # Optionally pass the user assigning them
    end

    after(:create) do |project, evaluator|
      evaluator.users.each do |user|
        create(:assignment, project: project, user: user, assigned_by: evaluator.assigned_by || user)
      end
    end
  end
end