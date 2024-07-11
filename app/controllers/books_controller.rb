class BooksController < ApplicationController
  before_action :authenticate_user! # Ensure the user is authenticated for all actions
  before_action :set_book, only: [:show, :update, :soft_destroy, :destroy_perm, :undelete]
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


# def create
#   @book = Book.new(book_params)
#   if @book.save

#     if current_user.manager? || current_user.employee?
#       store_book = StoreBook.new(book: @book, store: current_user.store)
#       unless store_book.save
#         render json: { errors: store_book.errors.full_messages }, status: :unprocessable_entity and return
#       end
#     end


#     render json: @book, status: :created
#   else
#     render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
#   end
# end

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

#DELETE /books/:id
# def destroy
#   if current_user.admin? || (current_user.manager? && @book.stores.exists?(id: current_user.store_id))
#     deletion_comment = params[:deletion_comment]
#     if @book.update(deletion_comment: deletion_comment)
#       @book.soft_delete
#       render json: { message: 'Book deleted successfully' }, status: :ok
#     else
#       render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity

#     end
#   else
#     render json: { errors: 'You are not authorized to delete this book' }, status: :forbidden
#   end
# end

# def destroy
#   if current_user.admin?
#     delete_book
#   elsif current_user.manager?
#     delete_book if current_user.store && @book.stores.exists?(id: current_user.store.id)
#     puts "STORE_ID after soft_deletion CONTROLLER: #{current_user.store.id}"
#   else
#     render json: { errors: 'You are not authorized to delete books' }, status: :forbidden
#   end
# end

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
  puts 'ENTERED DESTROY PERM'
  @book = Book.deleted.find_by(id: params[:id])

  if @book.nil?
    puts "Book not found with id: #{params[:id]}"
    render json: { errors: 'Book not found' }, status: :not_found
    return
  end

  puts "BOOK FOUND: #{@book.id}"

  if current_user.admin? || (current_user.manager? && @book.stores.exists?(id: current_user.store_id))
    puts "Current user role: #{current_user.role}"
    puts "Current user store ID: #{current_user.store_id}"
    puts "Book stores before destroy: #{@book.stores.pluck(:id)}"
    puts "Book deleted_at: #{@book.deleted_at}"

    unless @book.deleted_at.present?
      puts "Book has not been soft-deleted yet"
      render json: { errors: 'Book has not been soft-deleted yet' }, status: :unprocessable_entity
      return
    end

    if @book.destroy
      puts "Book destroyed successfully"
      render json: { message: 'Book permanently deleted successfully' }, status: :ok
    else
      puts "Unable to permanently delete the book: #{@book.errors.full_messages.join(', ')}"
      render json: { errors: 'Unable to permanently delete the book' }, status: :unprocessable_entity
    end
  else
    puts "Not authorized to delete the book"
    render json: { errors: 'You are not authorized to permanently delete this book' }, status: :forbidden
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
    render json: { errors: 'Book not found' }, status: :not_found unless @book
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
