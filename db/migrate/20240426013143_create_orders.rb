class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :address
      t.decimal :total_price
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :store, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
