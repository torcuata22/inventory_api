class Book < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :author, presence: true, length: { maximum: 100 }
  # validates :isbn, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :publication_details, presence: true
  has_and_belongs_to_many :stores
  has_many :shipment_items
  has_many :shipments, through: :shipment_items
  acts_as_paranoid
end
