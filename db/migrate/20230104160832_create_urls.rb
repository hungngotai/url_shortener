# frozen_string_literal: true

class CreateUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :urls do |t|
      t.string :original_url, null: false, unique: true
      t.string :shortened, null: false, unique: true

      t.timestamps
    end

    add_index :urls, :original_url
    add_index :urls, :shortened
  end
end
