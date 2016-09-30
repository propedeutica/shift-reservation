FactoryGirl.define do
  factory :agedOffspring do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    age { Faker::Number.between(6, 12) }
  end
end
