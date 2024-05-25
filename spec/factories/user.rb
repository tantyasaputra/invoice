# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'John' }
    last_name { 'Doe' }
    email { 'john.doe@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
