FactoryGirl.define do
  factory :gradedOffspring, class: GradedOffspring, parent: :offspring do
    grade { GradedOffspring.grades.keys.sample }
  end
end
