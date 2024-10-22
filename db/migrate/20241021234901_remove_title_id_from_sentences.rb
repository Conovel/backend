# frozen_string_literal: true

# sentencesテーブルからtitle_idを削除
class RemoveTitleIdFromSentences < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :sentences, column: :title_id if foreign_key_exists?(:sentences, column: :title_id)
    remove_index :sentences, :title_id if index_exists?(:sentences, :title_id)
    return unless column_exists?(:sentences, :title_id)

    remove_column :sentences, :title_id
  end
end
