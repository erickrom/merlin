FactoryGirl.define do
  factory :match do
    league
    group 1
    round 1
    local 'Barcelona'
    visitor 'Real Madrid'
    local_shield 'http://thumb.resfu.com/img_data/escudos/medium/3852.jpg?size=60x'
    visitor_shield 'http://thumb.resfu.com/img_data/escudos/medium/3852.jpg?size=60x'
    schedule DateTime.parse('2013-12-11 20:45:00')
    local_goals 3
    visitor_goals 0
  end
end
