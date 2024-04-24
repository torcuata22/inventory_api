class AddQuantityToStoreBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :store_books, :quantity, :integer
  end
end
