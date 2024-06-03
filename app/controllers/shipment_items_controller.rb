class ShipmentItemsController < ApplicationController

  def create
    @shipment_item = ShipmentItem.new(shipment_item_params)

    if @shipment_item.save
      render json: @shipment_item, status: :created
    else
      render json: @shipment_item.errors, status: :unprocessable_entity
    end
  end


  private

  def shipment_params
    params.require(:shipment).permit(:store_id, :arrival_date, shipment_items_attributes: [:book_id, :quantity])
  end


end
