class BooksController < ApplicationController
  before_action :set_book, only: [:show, :update, :destroy]

  def index
    books = Book.all
    render json: books
  end


  def show
    render json: @book
  end


  def create
    @book = Book.new(book_params)

    if @book.save
      render json: @book, status: :created
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def update
    if @book.update(book_params)
      render json: @book, status: :ok
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def destroy
    deletion_comment = params[:deletion_comment]
    if @book.update(deletion_comment: deletion_comment)
      if @book.destroy
        render json: { message: 'Book deleted successfully' }, status: :ok
      else
        render json: { errors: 'Unable to delete the book' }, status: :unprocessable_entity
      end
    end
  end

  def destroy_perm
    @book = Book.with_deleted.find(params[:id])
    if @book.really_destroy!
      render json: { message: 'Book permanently deleted successfully' }, status: :ok
    else
      render json: { errors: 'Unable to permanently delete the book' }, status: :unprocessable_entity
    end
  end

  def deleted_books
    @deleted_books = Book.only_deleted.where.not(deleted_at: nil)
    render json: @deleted_books
  end


  def undelete
    book_id = params[:id].to_i
    puts "BOOK ID: #{book_id}"
    @book = Book.only_deleted.find(book_id)
    unless @book
      render json: { errors: 'Book not found' }, status: :not_found
      return
    end

    if @book.recover
      render json: { message: 'Book undeleted successfully' }, status: :ok
    else
      render json: { errors: 'Unable to undelete the book' }, status: :unprocessable_entity
    end
  end



  private

  def set_book
    @book = Book.find(params[:id])
    unless @book
      render json: { errors: 'Book not found' }, status: :not_found
    end
  end

  def book_params
    params.require(:book).permit(:title, :author, :isbn, :description, :publication_details, :deletion_comment)
  end
end
