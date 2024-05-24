# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  alias_attribute :password_digest, :password_hash

  validates :first_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  has_many :invoices, dependent: :destroy
end
