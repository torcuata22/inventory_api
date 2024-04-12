class CreateStoreBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :store_books do |t|
      t.references :store, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
