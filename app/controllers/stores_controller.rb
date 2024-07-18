class StoresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_store, only: [:update, :destroy, :show, :inventory]
  before_action :set_admin_access, only: [:create, :update, :destroy]
  before_action :authorize_all_users, only: [:inventory, :search_by_title]


  def index
    stores = Store.all
    stores_with_book_counts = stores.map do |store|
      {
        id: store.id,
        store_name: store.store_name,
        store_address: store.store_address,
        store_type: store.store_type,
        manager: store.manager,
        books_count: store.books_count,
        books: store.books.map do |book|
          {
            id: book.id,
            title: book.title,
            author: book.author,
            isbn: book.isbn,
            description: book.description,
            publication_details: book.publication_details
          }
        end,
        copies_in_store: store.store_books.group(:book_id).count
      }
    end
    render json: stores_with_book_counts, status: :ok
  end




  def create
    @store = Store.new(store_params)

    if @store.save
      render json: @store, status: :created
    else
      render json: { errors: @store.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def update
    if @store.update(store_params)
      render json: @store
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end


  def destroy
    puts "Destroy action called"
    if @store.destroy
      render json: { message: 'Store deleted successfully' }, status: :ok
    else
      render json: { error: 'Failed to delete store' }, status: :unprocessable_entity
    end
  end

  def show
    render json: @store, status: :ok
  end


  def inventory
    if params[:title].present?
      puts "Title param present: #{params[:title]}"
      inventory_items = Book.where(title: params[:title], store_id: @store.id)
    else
      puts "Title param not present"
      inventory_items = @store.books
    end

    puts "Inventory items: #{inventory_items.inspect}"
    render json: inventory_items, each_serializer: BookSerializer
  end



  def sales
    @store = Store.find(params[:id])
    sales_params = params[:sales]
    sales_params.each do |sale|
      book_id = sale[:book_id]
      quantity_sold = sale[:quantity].to_i

      if quantity_sold <= 0
        render json: { error: "Quantity must be greater than zero" }, status: :unprocessable_entity
        return
      end

      book = Book.find_by(id: book_id)

      if book && @store.has_sufficient_inventory?(book, quantity_sold)
        @store.sell_book(book, quantity_sold)
      else
        render json: { error: "Book not found or insufficient inventory" }, status: :not_found
        return
      end
    end

    render json: { message: "Sales recorded successfully" }, status: :ok
  end


  def search_by_title
    if params[:title].present?
      stores = Store.all
      stores_with_books_matching_title = stores.map do |store|
        {
          id: store.id,
          store_name: store.store_name,
          store_address: store.store_address,
          store_type: store.store_type,
          manager: store.manager,
          books: store.books.where("title ILIKE ?", "%#{params[:title]}%").map do |book|
            {
              id: book.id,
              title: book.title,
              author: book.author,
              isbn: book.isbn,
              description: book.description,
              publication_details: book.publication_details
            }
          end
        }
      end
      render json: stores_with_books_matching_title, status: :ok
    else
      render json: { error: "Title parameter is missing" }, status: :unprocessable_entity
    end
  end



private

def set_store
  puts "Params ID: #{params[:id]}"
  @store = Store.find_by(id: params[:id])
  puts "Store found: #{@store.inspect}"
  rescue ActiveRecord::RecordNotFound
    puts "Store not found"
    render json: { error: 'Store not found' }, status: :not_found
end

def set_admin_access
  puts "set_admin_access called"
  unless current_user.admin?
    puts "Access forbidden for user: #{current_user.id}"
    render json: { error: 'unauthorized' }, status: :forbidden
  end
end

def authorize_all_users
  unless current_user.admin? || current_user.manager? || current_user.employee?
    render json: { error: 'Unauthorized' }, status: :forbidden
  end
end

def store_params
  params.require(:store).permit(:store_name, :store_address, :store_type, :manager)
end

end
