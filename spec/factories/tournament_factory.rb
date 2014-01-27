FactoryGirl.define do
  factory :tournament do
    sequence(:name)  { |n| "Tournament #{n}" }
    user { create(:user) }
  end
end
