FactoryBot.define do
  factory :store do
    store_name { 'Test Store' }
    store_address { '231 Main St. Manchester NH' }
    store_type { :mega } # Use symbolic name instead of integer
    manager { 'Loki Marquez' }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
    books_count { 2 } #integer

    # After creating a store, create associated books
    after(:create) do |store, evaluator|
      create_list(:store_book, evaluator.books_count, store: store) #used to be book instead of store_book
    end

  end
end
