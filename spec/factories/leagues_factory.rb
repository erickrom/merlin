FactoryGirl.define do
  factory :league do
    sequence(:name)  { |n| "League #{n}" }
    sequence(:external_id)
    year Time.now.year
    sequence(:group_code)
    playoff false
    current_round 1
    total_group 8
    total_rounds 8
    flag_url_path 'http://thumb.resfu.com/media/img/flags/44x27/ue.png'
  end
end
