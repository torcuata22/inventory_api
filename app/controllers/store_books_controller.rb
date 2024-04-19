class StoreBooksController < ApplicationController
  def create
    @store_book = StoreBook.new(store_book_params)

    if @store_book.save
      @store = Store.find(@store_book.store_id)
      @store.update_books_count  # Call the method to update the book count
      render json: @store_book, status: :created
    else
      render json: @store_book.errors, status: :unprocessable_entity
    end
  end

  private

  def store_book_params
    params.require(:store_books).permit(:store_id, :book_id)
  end
end
