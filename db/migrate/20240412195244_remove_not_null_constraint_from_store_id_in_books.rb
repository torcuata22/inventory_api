class RemoveNotNullConstraintFromStoreIdInBooks < ActiveRecord::Migration[7.1]
  def change
    change_column_null :books, :store_id, true
  end
end
