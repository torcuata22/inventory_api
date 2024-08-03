FactoryBot.define do
  factory :order do
    name { 'Bilbo Baggins' }
    address { 'The Grey Haven' }
    total_price { 100.0 }
    association :user, email: 'myotheruseremail@tests.com'
    association :store
    created_at { -> { Time.now } } #lambdas because I am creating a new order
    updated_at { -> { Time.now } }
  end
end
