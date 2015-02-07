FactoryGirl.define do
  factory :prediction do
    tournament
    user
    match
    local_goals 3
    visitor_goals 1
  end
end
