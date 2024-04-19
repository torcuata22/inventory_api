class CreateShipments < ActiveRecord::Migration[7.1]
  def change
    create_table :shipments do |t|
      t.references :book, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.date :arrival_date
      t.integer :quantity

      t.timestamps
    end
  end
end
