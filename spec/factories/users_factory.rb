FactoryGirl.define do
  factory :user do
    sequence(:first_name)  { |n| "Person#{n}" }
    last_name 'Example'
    sequence(:email) { |n| "person_#{n}@example.com"}
    password 'foobar'
    password_confirmation 'foobar'
  end
end
