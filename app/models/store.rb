class Store < ApplicationRecord
  enum store_type: { community: 0, mega: 1, warehouse: 2 }
  has_and_belongs_to_many :books

  validates :store_name, presence: true, length: { maximum: 255 }
  validates :store_address, presence: true, length: { maximum: 300 }
  validates :manager, presence: true, length: { maximum: 100 }
end
