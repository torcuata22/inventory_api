class StoreBooksController < ApplicationController

  before_action :authenticate_user!
  before_action :set_admin_access, only: [:index, :show, :create, :destroy]
  before_action :set_store, only: [:index, :show, :destroy]
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
    @store = Store.find(params[:store_id]) #filter based on store_id
    @book = Book.find(params[:store_book][:book_id]) #filter based on book_id
    @store_book = @store.store_books.build(book: @book) #build store_book with book_id, build method creates new record without saving to db

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
    params.require(:store_book).permit(:store_id, :book_id)
  end

  def update_book_quantity(book)
    book.update_quantity
  end

  def set_store
    @store = Store.find(params[:store_id])
  end

  def set_admin_access
    puts "set_admin_access called"
    unless current_user.admin?
      puts "Access forbidden for user: #{current_user.id}"
      puts "Rendering error response"
      render json: { error: 'unauthorized' }, status: :forbidden
    end
  end

end
