class ModifyShipmentsForeignKey < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :shipments, :books
    remove_foreign_key :shipments, :stores

    add_foreign_key :shipments, :books, on_delete: :cascade
    add_foreign_key :shipments, :stores, on_delete: :cascade

  end
end
