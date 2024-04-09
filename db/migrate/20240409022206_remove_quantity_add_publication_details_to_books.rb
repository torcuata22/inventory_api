class RemoveQuantityAddPublicationDetailsToBooks < ActiveRecord::Migration[7.1]
  def change
    remove_column :books, :quantity_on_hand, :integer
    add_column :books, :publication_details, :string
  end
end
