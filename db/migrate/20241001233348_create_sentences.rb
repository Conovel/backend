# frozen_string_literal: true

# This migration creates the sentences table
class CreateSentences < ActiveRecord::Migration[7.0]
  def change
    create_table :sentences do |t|
      t.text :sentence

      t.timestamps
    end
  end
end
