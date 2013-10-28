FactoryGirl.define do
  factory :employee do
    num "123"
    barcode "123"
    name {Faker::Name.name}
    name_cn "成龙"
    gender true
    dob '1970-01-23'
    soe '2012-02-03'
    eoe '2012-03-04'
    sin "123-456-789"
    department "Office"
    position 'Employee'
    rate 11.23
    active true
    status 'out'
    notes "notes 123"
  end
end


