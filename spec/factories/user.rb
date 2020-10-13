FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    address { Faker::Name.name }
    phone_number { Faker::PhoneNumber.unique.cell_phone.slice 0, 10}
    email { Faker::Internet.unique.email }
    password { "123456" }
    password_confirmation { "123456" }
    role { "user" }
  end
end
