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
    state :published
    state :paid
    state :expired

    event :publish do
      transitions from: :created, to: :published do
        after do |url|
          set_published_url(url)
        end
      end
    end
  end

  private

  def calculate_total_amount
    self.total_amount = invoice_items.sum { |item| item.quantity * item.item.unit_price }
  end
  def set_published_url(url)
    self.update(published_url: url)
  end
end
