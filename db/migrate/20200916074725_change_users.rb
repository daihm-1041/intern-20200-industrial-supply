class ChangeUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :admin, :role
  end
end
