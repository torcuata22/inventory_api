class StoresController < ApplicationController
  before_action :set_store, only: [:update, :destroy]


# def index
#     stores = Store.includes(:books).all
#     render json: stores.as_json(include: { books: { only: [], methods: :books_count } }), status: :ok
# end

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
  @store.destroy
end

private

def set_store
  @store = Store.find(params[:id])
end

def store_params
  params.require(:store).permit(:store_name, :store_address, :store_type, :manager)
end

end
