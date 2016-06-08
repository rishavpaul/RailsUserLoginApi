class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password
      t.string :access_token
      t.timestamp :access_token_valid_upto

      t.timestamps null: false
    end
  end
end
