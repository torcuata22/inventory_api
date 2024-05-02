class OrdersController < ApplicationController

  before_action :set_order, only: [:show, :update, :destroy]

  def index
    @orders = Order.all
    rende json: @orders
  end

  #GET /orders/:id
  def show
    render json: @order
  end

  #POST /orders
  def create
    @order = Order.new(order_params)
    book_ids = params[:book_ids]
    @order.books << Book.where(id: book_ids) if book_ids.present?  # Associate books with the order
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

  def set_order
    @order = Order.fid(params[:id])
  end

  def order_params
    params.require(:order).permit(:name, :address, :total_price, :store_id, :user_id)
  end


end
