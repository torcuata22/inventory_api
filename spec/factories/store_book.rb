FactoryBot.define do
  factory :store_book do
    book_id { 9 } #bigint
    store_id { 2 } #bigint
    created_at { Time.now }
    updated_at { Time.now }
    quantity { 12 } #integer
  end
end
