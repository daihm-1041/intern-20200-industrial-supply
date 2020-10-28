FactoryBot.define do
  factory :order do
    name_receiver { Faker::Name.name }
    address_receiver { Faker::Name.name }
    phone_receiver { Faker::PhoneNumber.unique.cell_phone.slice 0, 10 }
    status { "pending" }
    user { FactoryBot.create :user}
  end
end
