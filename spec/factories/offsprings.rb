FactoryGirl.define do
  factory :offspring do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    grade { Offspring.grades.keys.sample }
    user
  end
end
