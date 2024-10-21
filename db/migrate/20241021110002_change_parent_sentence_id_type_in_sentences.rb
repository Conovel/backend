# frozen_string_literal: true

# parent_sentence_idにマイグレーションエラーで反映されなかった設定を追加
class ChangeParentSentenceIdTypeInSentences < ActiveRecord::Migration[7.0]
  def change
    # 既存のカラムのデータ型を変更
    change_column :sentences, :parent_sentence_id, :bigint, null: false

    # 外部キー制約を追加
    add_foreign_key :sentences, :sentences, column: :parent_sentence_id, primary_key: :sentence_id

    # インデックスを追加
    add_index :sentences, :parent_sentence_id
  end
end
