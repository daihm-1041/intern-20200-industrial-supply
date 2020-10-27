FactoryBot.define do
  factory :order_detail do
    quantity { 5 }
    amount { 100000 }
    order { FactoryBot.create :order}
    product { FactoryBot.create :product }
  end
end
