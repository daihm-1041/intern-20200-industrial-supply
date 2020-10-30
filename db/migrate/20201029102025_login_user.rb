class LoginUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    remove_column :users, :password_digest
    remove_column :users, :remember_digest
  end
end
