# frozen_string_literal: true

# sentencesテーブルにtitle_idカラムを追加
class AddTitleIdToSentences < ActiveRecord::Migration[7.0]
  def change
    add_column :sentences, :title_id, :bigint, null: false unless column_exists?(:sentences, :title_id)
    unless foreign_key_exists?(:sentences, :titles, column: :title_id)
      add_foreign_key :sentences, :titles, column: :title_id, primary_key: :title_id
    end
    return if index_exists?(:sentences, :title_id)

    add_index :sentences, :title_id
  end
end
