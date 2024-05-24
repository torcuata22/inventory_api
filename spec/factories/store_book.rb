
FactoryBot.define do
  factory :store_book do
    association :book #creates association with a book
    association :store #cretes association with a store
    quantity { 12 } #integer
    created_at { Time.now }
    updated_at { Time.now }

  end
end
