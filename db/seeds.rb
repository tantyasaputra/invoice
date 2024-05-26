# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create users
User.create!(first_name: 'admin', last_name: 'admin', email: 'admin@example.com', password: 'password', password_confirmation: 'password')

# Create items
Item.create!(name: 'iPhone 13', description: 'Description for Phone 13', unit_price: 300.0)
Item.create!(name: 'iPhone 14', description: 'Description for Phone 14', unit_price: 400.0)
Item.create!(name: 'iPhone 15', description: 'Description for Phone 15', unit_price: 500.0)
