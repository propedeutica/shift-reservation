FactoryGirl.define do
  factory :agedOffspring, class: AgedOffspring, parent: :offspring do
    age { Faker::Number.between(6, 12) }
  end
end
