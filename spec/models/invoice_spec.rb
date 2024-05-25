# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    let(:user) { create(:user) }

    it 'is valid with valid attributes' do
      invoice = build(:invoice, user:)
      expect(invoice).to be_valid
    end

    it 'is invalid without a invoice_number' do
      invoice = build(:invoice, invoice_number: nil)
      expect(invoice).to_not be_valid
      expect(invoice.errors[:invoice_number]).to include("can't be blank")
    end

    it 'is invalid without a due_date' do
      invoice = build(:invoice, due_date: nil)
      expect(invoice).to_not be_valid
      expect(invoice.errors[:due_date]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'has many invoice_items' do
      assoc = described_class.reflect_on_association(:invoice_items)
      expect(assoc.macro).to eq :has_many
    end
  end

  describe '#update_total_amount' do
    let(:invoice) { create(:invoice, user: create(:user)) }

    it 'updates the total amount correctly' do
      item1 = create(:item, name: 'ItemA', unit_price: 10.0)
      item2 = create(:item, name: 'ItemB', unit_price: 20.0)
      create(:invoice_item, invoice:, item: item1, quantity: 2)
      create(:invoice_item, invoice:, item: item2, quantity: 3)

      invoice.update_total_amount

      expect(invoice.total_amount).to eq(80.0) # (2 * 10.0) + (3 * 20.0)
    end

    it 'sets the total amount to 0 if there are no invoice items' do
      invoice.update_total_amount
      expect(invoice.total_amount).to eq(0.0)
    end
  end
end
