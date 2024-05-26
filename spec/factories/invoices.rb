# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    association :user
    sequence(:invoice_number) { |n| "INV-#{1000 + n}" }
    due_date { '2024-06-06' }
    total_amount { 0 }
  end
end
