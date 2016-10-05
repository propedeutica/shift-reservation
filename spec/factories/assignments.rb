FactoryGirl.define do
  factory :assignment do
    association :user, factory: :user
    association :offspring,factory: :offspring
    association :shift, factory: :shift
  end
end
