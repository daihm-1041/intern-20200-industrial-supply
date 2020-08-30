class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :remember_digest
      t.string :address
      t.string :phone_number
      t.integer :admin

      t.timestamps
    end
  end
end
