# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name { 'IPhone 15' }
    description { 'Latest IPhone from apple with the best specification.' }
    unit_price { 799.0 }
  end
end
