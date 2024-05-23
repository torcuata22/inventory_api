FactoryBot.define do
  factory :shipment_item do
    association :shipment #instead of hard coding id
    association :book  #instead of hard coding id
    quantity { 35 } #numeric
    created_at { Time.now } #static
    updated_at { Time.now } #static

  end
end
