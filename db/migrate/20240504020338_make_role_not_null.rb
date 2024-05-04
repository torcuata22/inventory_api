class MakeRoleNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :role, :string, null: false, default: 'employee'
  end
end
