require 'pry'

RSpec.describe OrderItem, type: :model do
  describe "associations" do
    it "belongs to books" do
    association = OrderItem.reflect_on_association(:book)
    expect(association.macro).to eq :belongs_to
    end

    it "belongs to stores" do
      association = OrderItem.reflect_on_association(:order)
      expect(association.macro).to eq :belongs_to
    end
  end


end
