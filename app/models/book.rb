class Book < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :author, presence: true, length: { maximum: 100 }
  # validates :isbn, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :publication_details, presence: true
  has_many :store_books
  has_and_belongs_to_many :stores, through: :store_books
  has_many :shipment_items
  has_many :shipments, through: :shipment_items

  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :not_deleted, -> { where(deleted_at: nil) }


  def soft_delete
    update(deleted_at: Time.current)
  end

  def recover
    update(deleted_at: nil)
  end

  def deleted?
    deleted_at.present?
  end
end
