FactoryGirl.define do
  factory :shift do
    day_of_week 0
    start_time "10:00"
    end_time "10:45"
    sites_reserved 0
    association :room
  end
end
