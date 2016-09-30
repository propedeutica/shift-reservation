FactoryGirl.define do
  factory :gradedOffspring do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    grade { Faker::Number.between(1, 3) }
  end
end
