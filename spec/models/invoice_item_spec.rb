# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      invoice_item = create(:invoice_item, quantity: 1)
      expect(invoice_item).to be_valid
    end

    it 'is invalid with a quantity of zero' do
      invoice_item = build(:invoice_item, quantity: 0)
      expect(invoice_item).to_not be_valid
      expect(invoice_item.errors[:quantity]).to include('must be greater than 0')
    end

    it 'is invalid with a negative quantity' do
      # create(:user)
      invoice_item = build(:invoice_item, quantity: -1)
      expect(invoice_item).to_not be_valid
      expect(invoice_item.errors[:quantity]).to include('must be greater than 0')
    end
  end
end
