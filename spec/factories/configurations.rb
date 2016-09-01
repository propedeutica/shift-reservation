FactoryGirl.define do
  factory :configuration do
    singleton_guard 1
    global_lock false
  end
end
