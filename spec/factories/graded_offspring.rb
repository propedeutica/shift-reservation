FactoryGirl.define do
  factory :gradedOffspring, class: GradedOffspring, parent: :offspring do
    grade { Faker::Number.between(1, 3) }
  end
end
