FactoryGirl.define do
  factory :match do
    league
    group 1
    round 1
    local 'Barcelona'
    visitor 'Real Madrid'
    local_shield 'http://example.com'
    visitor_shield 'http://example.com'
    schedule DateTime.parse('2013-12-11 20:45:00')
    local_goals 3
    visitor_goals 0
  end
end
