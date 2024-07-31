class Store < ApplicationRecord
  enum store_type: { community: 0, mega: 1, warehouse: 2 }
  has_many :store_books, dependent: :destroy  # Define association with store_books
  has_and_belongs_to_many :books, through: :store_books

  # has_many :books, through: :store_books

  # before_destroy :update_books_count


  has_many :orders

  validates :store_name, presence: true, length: { maximum: 255 }
  validates :store_address, presence: true, length: { maximum: 300 }
  validates :manager, presence: true, length: { maximum: 100 }

  after_create :update_books_count
  after_destroy :update_books_count
  # before_destroy :update_books_count



  def update_books_count
    count = store_books.count
    puts "Books count from STORE model: #{count}"
    update_column(:books_count, count)
  end

  def has_sufficient_inventory?(book, quantity)
    store_book = store_books.find_by(book: book)
    return false unless store_book
    store_book.quantity >= quantity
  end

  def sell_book(book_id, quantity)
    store_book = store_books.find_by(book_id: book_id)
    return unless store_book

    quantity = quantity.to_i
    store_book.quantity = store_book.quantity.to_i - quantity
    store_book.save!
    store_book.quantity
  end


  # def sell_book(book, quantity_sold)
  #   store_book = store_books.find_by(book: book)
  #   if store_book
  #     store_book.update(quantity: store_book.quantity - quantity_sold)
  #     store_book.quantity
  #   else
  #     raise "Book not found in store"
  #   end
  # end


  # def sell_book(book, quantity)
  #   store_book = store_books.find_by(book: book)
  #   puts "ENTERING SELL_BOOK"
  #   if store_book
  #     puts "FOUND STORE_BOOK"
  #     puts "Before update: #{store_book.quantity}"
  #     new_quantity = store_book.quantity - quantity
  #     store_book.update!(quantity: new_quantity)
  #     puts "After update: #{store_book.reload.quantity}"
  #     new_quantity
  #   else
  #     puts "Book not found in store"
  #   end
  # end


  private

  def update_book_count_on_create
    update_books_count
  end

  def update_book_count_on_destroy
    update_books_count
  end
end
