class AddStoreToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :store, foreign_key: true
  end
end
