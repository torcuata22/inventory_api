class Shipment < ApplicationRecord
  belongs_to :store
  has_many :shipment_items
  has_many :books, through: :shipment_items

  after_create :update_inventory_count

  accepts_nested_attributes_for :shipment_items, allow_destroy: true

  private

  def update_inventory_count
    total_quantity = shipment_items.sum(:quantity)
    update_column(:quantity, total_quantity)
  end
end
