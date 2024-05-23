require 'pry'

RSpec.describe ShipmentItem, type: :model do
  describe "associations" do
    it "belongs to shipment" do
      association = ShipmentItem.reflect_on_association(:shipment)
      expect(association.macro).to eq :belongs_to
    end

    it "belongs to item" do
      association = ShipmentItem.reflect_on_association(:book)
      expect(association.macro).to eq :belongs_to
    end
  end
end
