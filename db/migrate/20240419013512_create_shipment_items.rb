class CreateShipmentItems < ActiveRecord::Migration[7.1]
  def change
    create_table :shipment_items do |t|
      t.references :shipment, null: false, foreign_key: { on_delete: :cascade }
      t.references :book, null: false, foreign_key: { on_delete: :cascade }
      t.integer :quantity

      t.timestamps
    end
  end
end
