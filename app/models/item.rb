# frozen_string_literal: true
class Item < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end