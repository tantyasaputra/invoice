# frozen_string_literal: true

class AddPublishedUrlColumn < ActiveRecord::Migration[7.1]
  def up
    add_column :invoices, :published_url, :string
  end

  def down
    remove_column :invoices, :published_url
  end
end
