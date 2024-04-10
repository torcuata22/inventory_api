class Book < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :author, presence: true, length: { maximum: 100 }
  validates :isbn, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :publication_details, presence: true
  belongs_to :store
end
