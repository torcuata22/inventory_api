class DropStoreBooks < ActiveRecord::Migration[7.1]
  def change
    drop_table :store_books
  end
end
