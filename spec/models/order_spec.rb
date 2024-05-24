require 'pry'

RSpec.describe Order, type: :model do
  let(:user) { create(:user, email: 'myotheruseremail@tests.com') }

  describe 'associations' do
    it "belongs to user" do
      association = Order.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it "belongs to store" do
      association = Order.reflect_on_association(:store)
      expect(association.macro).to eq :belongs_to
    end

    it "has many order_items" do
      association = Order.reflect_on_association(:order_items)
      expect(association.macro).to eq :has_many
    end

    it "has many books through order_items" do
      association = Order.reflect_on_association(:books)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :order_items
    end
  end

  describe 'dependent: :destroy' do
    let(:order) { create(:order, user: user) }

    it "destroys associated order_items when order is destroyed" do
      store = create(:store) # Create a Store record
    book = create(:book, store: store) # Associate the Store record with the Book
    # order = create(:order) # Create an Order record
    create(:order_item, order: order, book: book) # Associate the Book record with the OrderItem
    expect { book.destroy }.to change { Book.count }.by(-1)
    expect { order.destroy }.to change { OrderItem.count }.by(-1)
    end


  end
end
