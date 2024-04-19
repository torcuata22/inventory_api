class Shipment < ApplicationRecord
  has_many :shipment_items
  has_many :books, through: :shipment_items
  belongs_to :store

  after_create :update_inventory_count

  private
  def update_inventory_count
    total_quantity = shipment_items.sum(:quantity)
    update_column(:quantity, total_quantity)
  end

end
