class ShipmentItemsController < ApplicationController

  before_action :authenticate_user!
  before_action :authorize_all_users, only: [:create]


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

  def authorize_all_users
    unless current_user.admin? || current_user.manager? || current_user.employee?
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end

end
