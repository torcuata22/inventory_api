class CreateStoreBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :store_books do |t|
      t.references :book, null: false, foreign_key: {on_delete: :cascade}
      t.references :store, null: false, foreign_key: {on_delete: :cascade}
      t.timestamps
    end
  end
end
