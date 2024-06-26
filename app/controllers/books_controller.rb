class BooksController < ApplicationController
  before_action :set_book, only: [:show, :update, :destroy, :destroy_perm, :undelete]
  before_action :authenticate_user! # Ensure the user is authenticated for all actions
  before_action :authorize_admin_or_manager, only: [:create, :update, :destroy, :destroy_perm, :deleted_books, :undelete]


  def index
    books = Book.all
    render json: books
  end

   #GET /books/:id
  def show
    render json: @book
  end

#POST /books
def create
  @book = Book.new(book_params)

  if current_user.manager? || current_user.employee?
    @book.stores << current_user.store
  end

  if @book.save
    render json: @book, status: :created
  else
    render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
  end
end

#PUT /books/:id
def update
  if current_user.manager?
    unless @book.stores.exists?(id: current_user.store_id)
      render json: { errors: 'You are not authorized to update this book' }, status: :forbidden
      return
    end
  elsif !current_user.admin?
    render json: { errors: 'You are not authorized to update this book' }, status: :forbidden
    return
  end

  if @book.update(book_params)
    render json: @book, status: :ok
  else
    render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
  end
end


#THESE ACTIONS NEED TO BE UPDATED TO REFLECT PERMISSIONS
#DELETE /books/:id
def destroy
  if current_user.admin? || (current_user.manager? && @book.stores.exists?(id: current_user.store_id))
    deletion_comment = params[:deletion_comment]
    if @book.update(deletion_comment: deletion_comment)
      if @book.destroy
        render json: { message: 'Book deleted successfully' }, status: :ok
      else
        render json: { errors: 'Unable to delete the book' }, status: :unprocessable_entity
      end
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  else
    render json: { errors: 'You are not authorized to delete this book' }, status: :forbidden
  end
end


def destroy_perm
  puts 'ENTERED DESTROY PERM'
  @book = Book.with_deleted.find(params[:id])

  unless @book
    puts "Book not found"
    render json: { errors: 'Book not found' }, status: :not_found
  end

  puts "Book found: #{@book.inspect}"
  puts "Current user: #{current_user.inspect}"
  puts "Book count before destroy: #{Book.with_deleted.count}"

  if current_user.admin? || (current_user.manager? && @book.stores.exists?(id: current_user.store_id))
    if @book.really_destroy!
      puts 'book destroyed, really!'
      puts "Book count after destroy: #{Book.with_deleted.count}"
      render json: { message: 'Book permanently deleted successfully' }, status: :ok
    else
      puts 'book was not really destroyed'
      render json: { errors: 'Unable to permanently delete the book' }, status: :unprocessable_entity
    end
  else
    puts 'Not authorized to delete the book'
    render json: { errors: 'You are not authorized to permanently delete this book' }, status: :forbidden
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
    @book = Book.with_deleted.find_by(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Book not found' }, status: :not_found unless @book
  end

  def authorize_admin_or_manager
    # Allow if current user is admin
    return if current_user.admin?

    # If book is not set (e.g., during creation), allow managers
    return if current_user.manager? && action_name == 'create'

    # Otherwise, ensure the user is a manager of the book's store
    unless current_user.manager? && @book.stores.exists?(id: current_user.store_id)
      render json: { errors: 'You are not authorized to perform this action' }, status: :forbidden
    end
  end


  def book_params
    params.require(:book).permit(:title, :author, :isbn, :description, :publication_details, :deletion_comment)
  end
end
