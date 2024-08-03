class ShipmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_all_users, only: [:index, :show]
  before_action :authorize_admin_manager, only: [:create, :update, :destroy]
  before_action :set_store, only: [:create]
  before_action :set_shipment, only: [:show, :update, :destroy]

  def index
    @shipments = Shipment.all
    render json: @shipments
  end

  def show
    render json: @shipment
  end


  def create
    puts shipment_params
    @shipment = Shipment.new(shipment_params)
    @shipment.store_id = params[:store_id]
    if @shipment.save
      render :show, status: :created
    else
      render :new, status: :unprocessable_entity
    end
  end


  def update
    @store = @shipment.store
    if @shipment.update(shipment_params)
      render json: @shipment
    else
      render json: @shipment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @store = @shipment.store
    @shipment.destroy
    head :no_content
  end

  private

  # def shipment_params
  #   params.require(:shipment).permit(:store_id, :arrival_date, shipment_items_attributes: [:quantity, :book_id])
  # end


  # def shipment_params
  #   params.require(:shipment).permit(
  #     :arrival_date,
  #     shipment_items_attributes: [
  #       :id,
  #       :quantity,
  #       :book_id,
  #       :_destroy
  #     ]
  #     )
  # end

  def shipment_params
    params.require(:shipment).permit(:arrival_date, shipment_items_attributes: [:id, :quantity, :book_id])
  end


  def set_store
    @store = Store.find(params[:store_id])
  end

  def set_shipment
    @shipment = Shipment.find(params[:id])
  end

  def authorize_all_users
    unless current_user.admin? || current_user.manager? || current_user.employee?
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end

  def authorize_admin_manager
    unless current_user.admin? || current_user.manager?
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end


end
