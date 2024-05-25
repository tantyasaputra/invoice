# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    association :user
    invoice_number { 'INV#001' }
    due_date { '2024-06-06' }
    total_amount { 0 }
  end
end
