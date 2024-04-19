class RemoveBookIdFromShipments < ActiveRecord::Migration[7.1]
  def change
    remove_column :shipments, :book_id
  end
end
