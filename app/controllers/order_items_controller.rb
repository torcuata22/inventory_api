class OrderItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: [:index, :show, :create, :destroy]
  before_action :set_order, only: [:show, :create, :destroy]
  before_action :set_order_item, only: [:show, :destroy]

  def index
    @order_items = OrderItem.all
    render json: @order_items
  end

  def show
    # @store = Store.find(params[:store_id]) #filter based on store_id to find particular store
    # @order_item = @store.order_item
    render json: @order_item
  end

  def create
    @order_item = @order.order_items.new(order_item_params)
    if @order_item.save
      # Update the inventory for the associated store book
      update_inventory(@order_item.book, @order_item.quantity)
      render json: @order_item, status: :created
    else
      render json: @order_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @order_item.destroy
    head :no_content
  end


  # def create
  #   # @order_item = OrderItem.new(order_item_params)
  #   @order_item = @order.order_items.new(order_items)
  #   if @order_item.save
  #     # Update the inventory for the associated store book
  #     update_inventory(@order_item.book, @order_item.quantity)
  #     render json: @order_item, status: :created
  #   else
  #     render json: @order_item.errors, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   @order_item.destroy
  #   head :no_content
  # end

  private

    def set_order
      @order = Order.find(params[:order_id])
    end

    def set_order_item
      @order_item = @order.order_items.find(params[:id])
    end

    def set_store
      @store = Store.find(params[:store_id])
    end
    def set_order_item
      @order_item = @order.order_items.find(params[:id])
    end
    # def order_item_params
    #   params.require(:order_item).permit(:order_id, :book_id, :quantity)
    # end
    def order_item_params
      params.require(:order_item).permit(:book_id, :quantity)
    end

    def update_inventory(book, quantity)
      # Find the store book record
      store_book = StoreBook.find_by(book_id: book.id)
      return unless store_book

      # Update the quantity of the book in inventory
      store_book.update(quantity: store_book.quantity + quantity)
    end

    def authorize_admin
      unless current_user.admin?
        render json: { error: 'Forbidden' }, status: :forbidden
      end
    end
  end
