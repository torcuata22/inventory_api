class StoreBooksController < ApplicationController



  def create
    @store_book = StoreBook.new(store_book_params)

    if @store_book.save
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
