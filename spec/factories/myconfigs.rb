FactoryGirl.define do
  factory :myconfig do
    singleton_guard 1
    global_lock false
  end
end
