class ShipmentItem < ApplicationRecord
  belongs_to :shipment
  belongs_to :book

  validates :shipment, presence: true
  validates :book, presence: true
end
