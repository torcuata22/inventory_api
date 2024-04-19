class ShipmentsController < ApplicationController
  before_action :set_shipment, only: [:show, :update, :destroy]

  def index
    @shipments = Shipment.all
    render json: @shipments
  end

  def show
    render json: @shipment
  end

  def create
    @shipment = Shipment.new(shipment_params)

    if @shipment.save
      render json: @shipment, status: :created
    else
      render json: @shipment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @shipment.update(shipment_params)
      render json: @shipment
    else
      render json: @shipment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @shipment.destroy
  end

  private

  def shipment_params
    params.require(:shipment).permit(:store_id, :arrival_date, shipment_items_attributes: [:quantity, :book_id])
  end


  def set_shipment
    @shipment = Shipment.find(params[:id])
  end
end
