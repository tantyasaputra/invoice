# frozen_string_literal: true

class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  validates :quantity, numericality: { greater_than: 0 }
  after_update :update_invoice_total_amount
  after_destroy :update_invoice_total_amount

  private

  def update_invoice_total_amount
    invoice.update_total_amount
  end
end
