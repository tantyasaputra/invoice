# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      item = build(:item) # Assuming you have a factory for Item
      expect(item).to be_valid
    end

    it 'is invalid without a name' do
      item = build(:item, name: nil)
      expect(item).to_not be_valid
      expect(item.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a unit_price' do
      item = build(:item, unit_price: nil)
      expect(item).to_not be_valid
      expect(item.errors[:unit_price]).to include("can't be blank")
    end

    it 'is invalid with a negative price' do
      item = build(:item, unit_price: -1)
      expect(item).to_not be_valid
      expect(item.errors[:unit_price]).to include('must be greater than or equal to 0')
    end
  end
end
