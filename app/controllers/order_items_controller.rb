class OrderItemsController < ApplicationController

  def create
    @order_item = OrderItem.new(order_item_params)

    if @order_item.save
      # Update the inventory for the associated store book
      update_inventory(@order_item.book, @order_item.quantity)
      render json: @order_item, status: :created
    else
      render json: @order_item.errors, status: :unprocessable_entity
    end
  end

    private

    def order_item_params
      params.require(:order_item).permit(:order_id, :book_id, :quantity)
    end

    def update_inventory(book, quantity)
      # Find the store book record
      store_book = StoreBook.find_by(book_id: book.id)
      return unless store_book

      # Update the quantity of the book in inventory
      store_book.update(quantity: store_book.quantity + quantity)
    end
  end
