FactoryBot.define do
  factory :order_item do
    order_id { 654789 } #big int
    book_id { 329 } #big int
    quantity { 35 } #numeric
    price { 59.99 }
    updated_at { Time.now } #static, so no lambda
  end
end
