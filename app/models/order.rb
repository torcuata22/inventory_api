class Order < ApplicationRecord
  belongs_to :user
  belongs_to :store
  has_many :order_items, dependent: :destroy
  has_many :books, through: :order_items
end
