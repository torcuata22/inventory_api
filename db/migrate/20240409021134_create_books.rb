class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :isbn
      t.text :description
      t.decimal :price
      t.integer :quantity_on_hand

      t.timestamps
    end
  end
end
