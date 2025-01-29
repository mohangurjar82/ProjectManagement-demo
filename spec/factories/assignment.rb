FactoryBot.define do
  factory :assignment do
    user
    project
    assigned_by { create(:user) } 
    uuid { SecureRandom.uuid } 
  end
end