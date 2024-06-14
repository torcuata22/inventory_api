FactoryBot.define do
  factory :store do
    store_name { 'Test Store' }
    store_address { '231 Main St. Manchester NH' }
    store_type { 1 } #integer
    manager { 'Loki Marquez' }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
    books_count { 12 } #integer

    # After creating a store, create associated books
    after(:create) do |store, evaluator|
      create_list(:book, evaluator.books_count, store: store)
    end

  end
end
