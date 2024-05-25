require 'pry'

RSpec.describe Shipment, type: :model do
  let(:store) { create(:store) }

  describe 'associations' do

    it "belongs to store" do
      association = Shipment.reflect_on_association(:store)
      expect(association.macro).to eq :belongs_to
    end

    it "has many shipment_items" do
      association = Shipment.reflect_on_association(:shipment_items)
      expect(association.macro).to eq :has_many
    end

    it "has many books through shipment_items" do
      association = Shipment.reflect_on_association(:books)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :shipment_items
    end
  end

  describe 'dependent: :destroy' do
    it "destroys associated shipment_items when shipment is destroyed" do
      shipment = create(:shipment, store: store)
      create(:shipment_item, shipment: shipment)
      # expect(association.options[:through]).to eq :shipment_items
      expect { shipment.destroy }.to change { ShipmentItem.count }.by(-1)
    end
  end

  describe 'nested attributes' do
    it "accepts nested attributes for shipment_items" do
      shipment_attributes = attributes_for(:shipment).merge(
        shipment_items_attributes: [attributes_for(:shipment_item)]
      )
      shipment = Shipment.new(shipment_attributes)

      expect(shipment.shipment_items.size).to eq(1)
    end
  end

  describe 'callbacks' do
    it "updates inventory count after create" do
      shipment = create(:shipment, store: store)
      create(:shipment_item, shipment: shipment, quantity: 50)
      create(:shipment_item, shipment: shipment, quantity: 25)
      shipment.send(:update_inventory_count)
      shipment.reload

      expect(shipment.quantity).to eq(75)
    end
  end
end
