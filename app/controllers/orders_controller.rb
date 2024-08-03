class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_all_users, only: [:index, :create, :show, :update, :destroy]
  before_action :set_store, only: [:create, :update]
  before_action :set_order, only: [:show, :update, :destroy]

  def index
    @orders = Order.all
    render json: @orders
  end

  #GET /orders/:id
  def show
    render json: @order
  end

  def create
    @order = @store.orders.new(order_params)

    if params[:book_ids].present?
      @order.books << Book.where(id: params[:book_ids])
    end

    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  #PATCH/PUT /orders/:id
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  #DELETE /orders/:id
  def destroy
    @order.destroy
  end


  private

  def order_params
    params.require(:order).permit(:name, :address, :total_price, :store_id, :user_id)
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def set_store
    store_id = params.dig(:order, :store_id) # Extract store_id from order parameters
    @store = Store.find(store_id) if store_id.present?
  end
  # def set_store
  #   puts "Parameters: #{params.inspect}"
  #   @store = Store.find(params[:store_id])
  # end
def authorize_all_users
    unless current_user.admin? || current_user.manager? || current_user.employee?
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end
end
