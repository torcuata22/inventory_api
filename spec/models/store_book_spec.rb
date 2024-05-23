require 'pry'

RSpec.describe StoreBook, type: :model do


    describe "associations" do
      it "belongs to books" do
      association = StoreBook.reflect_on_association(:book)
      expect(association.macro).to eq :belongs_to
      end

      it "belongs to stores" do
        association = StoreBook.reflect_on_association(:store)
        expect(association.macro).to eq :belongs_to
      end
    end

    describe "methods" do
      it "updates inventory quantity" do
        # Create store and book with associations
        store = create(:store)
        book = create(:book, store: store)

        # Now create the store_book with the created book and store
        store_book = create(:store_book, book: book, store: store, quantity: 10)
        store_book.update_inventory(20)
        expect(store_book.quantity).to eq(20)
      end
    end
  end
