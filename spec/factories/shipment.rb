FactoryBot.define do
  factory :shipment do
    store_id { 7689321553 }
    arrival_date { Date.today } #the data type is "date" becasue I will have them enter it manually
    quantity { 75 }
    created_at { -> { Time.now } } #dynamic because I am creating a shipment
    updated_at { -> { Time.now } } #dynamic because I am creating a shipment
    dispatch_date { Date.today } #the data type is "date" becasue i will have them enter it manually
  end
end
