FactoryGirl.define do
  factory :assignment do
    association :user
    association :offspring
    association :shift
  end
end
