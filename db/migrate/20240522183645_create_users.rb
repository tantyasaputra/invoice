# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_hash

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
