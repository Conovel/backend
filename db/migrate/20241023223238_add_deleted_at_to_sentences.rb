# frozen_string_literal: true

# sentencesテーブルにdeleted_atカラムを追加（論理削除）
class AddDeletedAtToSentences < ActiveRecord::Migration[7.0]
  def change
    add_column :sentences, :deleted_at, :datetime
    add_index :sentences, :deleted_at # indexは不要な場合は後で削除（ドキュメントではindexが設定推奨）
  end
end
