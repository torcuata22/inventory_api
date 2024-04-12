class StoreBooksController < ApplicationController

  def create
    @store_book = StoreBook.new(store_book_params)
    if @store_book.save
      render json: @store_book, status: :created, location: @store_book
    else
      render json: @store_book.errors, status: :unprocessable_entity
    end
  end
end
