# frozen_string_literal: true

class CreateInvoiceItem < ActiveRecord::Migration[7.1]
  def up
    create_table :invoice_items do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end
  end

  def down
    drop_table :invoice_items
  end
end
