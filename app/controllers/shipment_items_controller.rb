class ShipmentItemsController < ApplicationController

  before_action :authenticate_user!
  before_action :authorize_admin, only: [:index, :show, :create, :destroy]
  before_action :set_shipment, only: [:create, :destroy]
  before_action :set_shipment_item, only: [:destroy]

  def index
    @shipment_items = ShipmentItem.all
    render json: @shipment_items
  end

  def show
    # @shipment_item = ShipmentItem.find(params[:id])
    render json: @shipment_item
  end
  def create
    @shipment_item = @shipment.shipment_items.new(shipment_item_params)

    if @shipment_item.save
      render json: @shipment_item, status: :created
    else
      render json: @shipment_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @shipment_item.destroy
    head :no_content
  end

  private

  def shipment_item_params
    params.require(:shipment_item).permit(:book_id, :quantity)
  end
  # def shipment_params
  #   # params.require(:shipment).permit(:store_id, :arrival_date, shipment_items_attributes: [:book_id, :quantity])
  #   params.require(:shipment_item).permit(:book_id, :quantity)
  # end

  def set_shipment
    # @shipment_item = @shipment.shipment_item.find(params[:shipment_id])
    @shipment = Shipment.find(params[:shipment_id])
  end

  def set_shipment_item
    @shipment_item = ShipmentItem.find(params[:id])
  end

  def authorize_admin
    unless current_user.admin?
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end

end
