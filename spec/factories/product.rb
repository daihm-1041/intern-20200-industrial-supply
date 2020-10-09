FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    inventory_number { 100 }
    price { 100000 }
    description { Faker::Lorem.paragraph }

    association :supplier
    association :category
  end
end
