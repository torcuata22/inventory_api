class StoreBook < ApplicationRecord
  belongs_to :store
  belongs_to :book

  def update_inventory(quantity)
    update(quantity: quantity)
  end

end
