# frozen_string_literal: true

class CreateInvoice < ActiveRecord::Migration[7.1]
  def up
    create_table :invoices do |t|
      t.references :user, null: false, foreign_key: true
      t.string :aasm_state
      t.string :invoice_number, null: false
      t.date :due_date, null: false
      t.decimal :total_amount, precision: 8, scale: 2, default: 0.0

      t.timestamps
    end

    add_index :invoices, :invoice_number, unique: true
  end

  def down
    drop_table :invoices
  end
end
