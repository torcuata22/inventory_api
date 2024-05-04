FactoryBot.define do
  factory :store do
    store_name { 'Test Store' }
    store_address { '231 Main St. Manchester NH' }
    store_type { 1 } #integer
    manager { 'Loki Marquez' }
    created_at { Time.now }
    updated_at { Time.now }
    books_count { 1 } #integer
  end
end
