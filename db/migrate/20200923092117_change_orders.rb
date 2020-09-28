class ChangeOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :name_receiver, :string
    add_column :orders, :address_receiver, :string
    add_column :orders, :phone_receiver, :string
    add_column :orders, :code, :string
    change_column :orders, :status, :integer, default: 3
  end
end
