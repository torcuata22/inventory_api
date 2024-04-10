class CreateStores < ActiveRecord::Migration[7.1]
  def change
    create_table :stores do |t|
      t.string :store_name
      t.string :store_address
      t.integer :store_type, default: 0
      t.string :manager

      t.timestamps
    end
  end
end
