class Store < ApplicationRecord
  enum store_type: { community: 0, mega: 1, warehouse: 2 }
  has_and_belongs_to_many :books
  has_many :store_books, dependent: :destroy  # Define association with store_books

  validates :store_name, presence: true, length: { maximum: 255 }
  validates :store_address, presence: true, length: { maximum: 300 }
  validates :manager, presence: true, length: { maximum: 100 }

  after_create :update_books_count
  after_destroy :update_books_count

  def update_books_count
    update_column(:books_count, store_books.count)
    puts store_books.count
  end

  private

  def update_book_count_on_create
    update_books_count
  end

  def update_book_count_on_destroy
    update_books_count
  end
end
