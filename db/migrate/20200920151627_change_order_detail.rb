class ChangeOrderDetail < ActiveRecord::Migration[6.0]
  def change
    add_column :order_details, :amount, :float
  end
end
