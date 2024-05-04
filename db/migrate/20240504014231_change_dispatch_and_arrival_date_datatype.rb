class ChangeDispatchAndArrivalDateDatatype < ActiveRecord::Migration[7.1]
  def change
    add_column :shipments, :dispatch_date, :date
    change_column :shipments, :arrival_date, :date
  end
end
