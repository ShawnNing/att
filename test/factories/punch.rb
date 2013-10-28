FactoryGirl.define do
  factory :punch do
    action "checkin"
    time Time.now - 1.hour
    employee
  end
end


