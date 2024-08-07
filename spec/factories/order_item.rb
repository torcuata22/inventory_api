FactoryBot.define do
  factory :order_item do
    association :order
    association :book
    quantity { 35 }
    price { 59.99 }
    updated_at { Time.now } #static, so no lambda
  end
end
