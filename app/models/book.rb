class Book < ApplicationRecord
  acts_as_paranoid
  validates :title, presence: true, length: { maximum: 255 }
  validates :author, presence: true, length: { maximum: 100 }
  # validates :isbn, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :publication_details, presence: true
  has_many :store_books
  has_and_belongs_to_many :stores, through: :store_books
  has_many :shipment_items
  has_many :shipments, through: :shipment_items

  def really_destroy!
    puts "Entering really_destroy! method for BOOK ID: #{self.id}"
    result = self.class.unscoped.where(id: self.id).delete_all
    puts "Number of records deleted: #{result}"
    result
  end

end
