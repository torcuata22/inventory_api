FactoryBot.define do
  factory :shipment_item do
    shipment_id { 8765003 } #bigint
    book_id { 33289 } #bigint
    quantity { 35 } #numeric
    created_at { Time.now } #static
    updated_at { Time.now } #static

  end
end
