# frozen_string_literal: true

class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :invoice_number, :aasm_state, :due_date, :total_amount, :published_url,
             :created_at, :updated_at
end
