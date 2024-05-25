# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_item do
    association :invoice
    association :item
    quantity { 1 }
  end
end
