class StoreBook < ApplicationRecord
  belongs_to :store
  belongs_to :book


  def update_inventory(new_quantity)
    update(quantity: new_quantity)
    reload
  end

end
