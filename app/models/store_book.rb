class StoreBook < ApplicationRecord
  belongs_to :store
  belongs_to :book


  def update_inventory(new_quantity)
    update(quantity: new_quantity)
    reload
    puts "THIS IS THE QUANTITY AFTER UPDATE INVENTORY METHOD: #{quantity}"
  end

end
