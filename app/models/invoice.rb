# frozen_string_literal: true

class Invoice < ApplicationRecord
  include AASM
  belongs_to :user
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  accepts_nested_attributes_for :invoice_items

  validates :user_id, :invoice_number, :due_date, presence: true
  validates :invoice_number, uniqueness: true

  before_save :calculate_total_amount

  aasm do
    state :created, initial: true
    state :paid
    state :expired
  end

  private

  def calculate_total_amount
    self.total_amount = invoice_items.sum { |item| item.quantity * item.item.unit_price }
  end
end
