FactoryGirl.define do
  factory :admin do
    email     Faker::Internet.safe_email
    password  'foobar123.'
  end
end
