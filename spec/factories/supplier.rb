FactoryBot.define do
  factory :supplier do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    detail { Faker::Lorem.paragraph }
  end
end
