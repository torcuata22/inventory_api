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
    deleted_at { nil } #used to be Time.now

    #Associations:
    after(:create) do |book|
      #Create store and associate it with the book (this book is in this store)
      store = create(:store)
      book.stores << store
      #Create store_book:
      create(:store_book, book: book)

      #Create shipment items and associate them with the book:
      3.times do
        shipment = create(:shipment)
        create(:shipment_item, book: book, shipment: shipment)

      end
    end
  end
end
