FactoryBot.define do
  factory :category do
    name { Faker::Name.name }
    detail { Faker::Lorem.paragraph }
  end
end
