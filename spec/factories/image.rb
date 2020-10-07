FactoryBot.define do
  factory :image do
    product { FactoryBot.create product }
    image_data { Faker::Avatar.image }
  end
end
