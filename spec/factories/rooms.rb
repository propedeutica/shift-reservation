FactoryGirl.define do
  factory :room do
    name { Faker::Name.name }
    capacity { Faker::Number.between(15, 25) }
  end
end
