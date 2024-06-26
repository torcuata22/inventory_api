class StoreBooksController < ApplicationController

  def index
    @store_books = StoreBook.all
    render json: @store_books
  end

  def show
    @store = Store.find(params[:store_id]) #filter based on store_id to find particular store
    @store_books = @store.store_books
    render json: @store_books
  end


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


  def destroy
    @store_book = StoreBook.find(params[:id])
    @book = @store_book.book
    @store_book.destroy
    update_book_quantity(@book) if @book.present?
    head :no_content
  end


  private

  def store_book_params
    params.require(:store_books).permit(:store_id, :book_id)
  end

  def update_book_quantity(book)
    book.update_quantity
  end

end
