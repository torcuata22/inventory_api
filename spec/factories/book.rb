FactoryBot.define do
  factory :book do
    title { 'The Title' }
    author { 'John Doe' }
    isbn { '123456789' }
    description { 'this is the description of the book' }
    price { 9.99 }
    created_at { Time.now }
    updated_at { Time.now }
    publication_details { 'these are the pub details for the book' }
    deletion_comment { 'comment made upon soft delete' }
    deleted_at { nil }

    transient do
      store { nil } # Ensure `store` is set to `nil` or a valid store instance
    end

    after(:create) do |book, evaluator|
      if evaluator.store
        book.stores << evaluator.store
        create(:store_book, book: book, store: evaluator.store)
      end

      3.times do
        shipment = create(:shipment, store: evaluator.store) if evaluator.store
        create(:shipment_item, book: book, shipment: shipment) if shipment
      end
    end
  end
end
