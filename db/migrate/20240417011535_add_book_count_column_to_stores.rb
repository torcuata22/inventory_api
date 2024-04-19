class AddBookCountColumnToStores < ActiveRecord::Migration[7.1]
  def change
    add_column :stores, :books_count, :integer, default: 0
  end
end
