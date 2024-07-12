class BooksController < ApplicationController
  before_action :authenticate_user! # Ensure the user is authenticated for all actions
  before_action :set_book, only: [:show, :update, :soft_destroy] #removed :destroy_perm, :undelete frmo the list
  before_action :set_soft_deleted_book, only: [:destroy_perm, :undelete]
  before_action :authorize_admin_or_manager, only: [:create, :update, :soft_destroy, :destroy_perm, :deleted_books, :undelete]


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

  if current_user.manager?
    @book.stores << current_user.store
    puts "FROM CONTROLLER --CURRENT USER STORE ID FROM CONTROLLER: #{current_user.store_id}"
    puts "FROM CONTROLLER --BOOK STORES: #{@book.stores.pluck(:id)}"
  end

  if @book.save
    puts "FROM CONTROLLER --BOOK CREATED: #{@book.inspect}"
    render json: @book, status: :created
  else
    puts "FROM CONTROLLER --BOOK CREATION FAILED: #{@book.errors.full_messages}"
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


def soft_destroy
  puts "ENTERED SOFT DELETE"
  if current_user.admin? || (current_user.manager? && @book.stores.exists?(id: current_user.store_id))
    if @book.soft_delete
      puts "FROM SOFT DELETE IN CONTROLLER: DELETED_AT FLAG SET TO: #{@book.deleted_at}"
      render json: { message: 'Book deleted successfully' }, status: :ok
    else
      render json: { errors: 'Unable to delete the book' }, status: :unprocessable_entity
    end
  else
    render json: { errors: 'You are not authorized to delete this book' }, status: :forbidden
  end
  puts "FINISHED SOFT DELETE"
end


# DELETE /books/:id/permanent
def destroy_perm
  @book = Book.deleted.find_by(id: params[:id])

  # if @book
  #   puts "Found book with ID: #{@book.id}"
  #   puts "Current user: #{current_user.email}, Role: #{current_user.role}, Store ID: #{current_user.store_id}"
  #   puts "Book stores: #{@book.stores.pluck(:id)}"
  #   puts "Soft deleted: #{@book.deleted_at.present?}"
  # else
  #   puts "No book found"
  # end

  unless @book
    render json: { message: 'Book not found' }, status: :not_found
    return
  end

  unless current_user.admin? || (current_user.manager? && @book.stores.exists?(id: current_user.store_id))
    render json: { error: 'Unaithorized to delete this book' }, status: :unauthorized
    return
    end

    if @book.destroy
      render json: { message:'Book deleted permanently' }, status: :ok
      puts "Book destroyed"

    else
      render json: { error: 'Failed to delete book', errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
end



  def deleted_books
    @deleted_books = Book.not_deleted.where.not(deleted_at: nil)
    render json: @deleted_books
  end


  def undelete
    book_id = params[:id].to_i
    puts "BOOK ID: #{book_id}"
    @book = Book.not_deleted.find(book_id)
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
    @book = Book.not_deleted.find_by(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Book not found' }, status: :not_found
  end

  def set_soft_deleted_book
    @book  = Book.deleted.find_by(id: params[:id])
    rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Soft-deleted book not found' }, status: :not_found
  end

  def authorize_admin_or_manager
    # Allow if current user is admin
    return if current_user.admin?

    # If book is not set (e.g., during creation), allow managers
    return if current_user.manager? && action_name == 'create'

    # Otherwise, ensure the user is a manager of the book's store
    unless current_user.manager? && @book && @book.stores.exists?(id: current_user.store_id)
      render json: { errors: 'You are not authorized to perform this action' }, status: :forbidden
    end
  end


  def book_params
    params.require(:book).permit(:title, :author, :isbn, :description, :publication_details, :deletion_comment, :deleted_at)
  end


  def delete_book
    deletion_comment = params[:deletion_comment]
    if @book.update(deletion_comment: deletion_comment)
      @book.soft_delete
      render json: { message: 'Book deleted successfully' }, status: :ok
    else
      render json: { errors: 'Unable to delete the book' }, status: :unprocessable_entity
    end
  end
end
