FactoryBot.define do
  factory :book do
    title { 'The Title' }
    author { 'John Doe' }
    isbn { '123456789' }
    description { 'this is the description of the book' }
    price { 9.99 } #numeric
    created_at { Time.now }
    updated_at { Time.now }
    publication_details { 'these are the pub details for the book' }
    store_id { 987654321 } #big int
    deletion_comment { 'comment made upon soft delete' }
    deleted_at { Time.now }
  end
end
