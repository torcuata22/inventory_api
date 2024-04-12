class StoresController < ApplicationController
  before_action :set_store, only: [:update, :destroy]


def index
  @stores = Store.all
  render json: @stores
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
