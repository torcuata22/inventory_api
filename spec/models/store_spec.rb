require 'pry'

RSpec.describe Store, type: :model do
  let(:store) { create(:store) }
  let(:book) { create(:book) }
  let!(:store_book) { create(:store_book, store: store, book: book, quantity: 100) }


  describe 'validations' do
    it "is invalid without a store name" do
      store = build(:store, store_name: nil)
      expect(store).to_not be_valid
    end

    it "is invalid without a store address" do
      store = build(:store, store_address: nil)
      expect(store).to_not be_valid
    end

    it "is invalid without a manager" do
      store = build(:store, manager: nil)
      expect(store).to_not be_valid
    end

    it "is valid with all attributes present" do
      store = build(:store)
      expect(store).to be_valid
    end

    it "is invalid if store_name is longer than 256 characters" do
      store=build(:store, store_name: 'a' * 256)
      expect(store).to_not be_valid
    end

    it "is invalid if store_address is longer than 300 characters" do
      store = build(:store, store_address: 'a' * 301)
      expect(store).to_not be_valid
    end

    it "is invalid if manager is longer than 100 characters" do
      store = build(:store, manager: 'a' * 101)
      expect(store).to_not be_valid
    end
  end

  describe 'associations' do

    it "has many orders" do
      association = Store.reflect_on_association(:orders)
      expect(association.macro).to eq :has_many
    end

    it "has many and belongs to many books" do
      association = Store.reflect_on_association(:books)
      expect(association.macro).to eq :has_and_belongs_to_many
    end

    it "has many  store_books" do
      association = Store.reflect_on_association(:store_books)
      expect(association.macro).to eq :has_many
    end
  end

  describe 'dependent: :destroy' do
    it "destroys associated store_books when store is destroyed" do
      store = create(:store)
      create(:store_book, store: store)
      expect { store.destroy }.to change { StoreBook.count }.by(-1)
    end
  end

  describe "#has_sufficient_inventory?" do
    it "returns true if the store has sufficient inventory of one book" do
      expect(store.has_sufficient_inventory?(book, 50)).to be true
    end

    it "returns false if the store does not have sufficient inventory of the book" do
      expect(store.has_sufficient_inventory?(book, 150)).to be false
    end
  end


  describe '#sell_book' do
    it 'decreases the quantity of the book in the store by the given amount' do
      store.sell_book(book, 50)
      expect(store_book.reload.quantity).to eq(50)

    end

    it 'does nothing if the store does not have the book' do
      other_book = create(:book)
      expect { store.sell_book(other_book, 50) }.not_to change { store_book.reload.quantity }
    end
  end

  describe 'callbacks' do
    before do
      store_book = store.store_books.first
      store_book.destroy
      store.reload
    end

    it 'updates books_count after destroy' do
      store_book.destroy
      expect(store.reload.books_count).to eq(0)
    end
  end
end
