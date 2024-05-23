# frozen_string_literal: true

class AddItem < ActiveRecord::Migration[7.1]
  def up
    create_table :items do |t|
      t.string :name
      t.text :description
      t.decimal :unit_price, precision: 8, scale: 2

      t.timestamps
    end
  end

  def down
    drop_table :items
  end
end
