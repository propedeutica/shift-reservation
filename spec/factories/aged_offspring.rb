FactoryGirl.define do
  factory :agedOffspring do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    age 12
  end
end
