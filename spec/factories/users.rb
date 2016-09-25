FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone "914270000"
    email     { Faker::Internet.safe_email("#{first_name}.#{last_name}") }
    password  'foobar123.'
  end
end
