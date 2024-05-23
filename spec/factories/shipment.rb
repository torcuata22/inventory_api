FactoryBot.define do
  factory :shipment do
    association :store
    arrival_date { Date.today }
    quantity { 75 }
    created_at { Time.now }
    updated_at { Time.now }
    dispatch_date { Date.today }
  end
end
