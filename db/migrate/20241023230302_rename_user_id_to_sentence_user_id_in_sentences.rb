# frozen_string_literal: true

# user_idカラムをsentence_user_idカラムに変更
class RenameUserIdToSentenceUserIdInSentences < ActiveRecord::Migration[7.0]
  def change
    # 外部キー制約を削除
    remove_foreign_key :sentences, column: :user_id if foreign_key_exists?(:sentences, column: :user_id)

    # カラム名を変更
    rename_column :sentences, :user_id, :sentence_user_id if column_exists?(:sentences, :user_id)

    # 新しいカラムに外部キー制約を追加
    unless foreign_key_exists?(:sentences, column: :sentence_user_id)
      add_foreign_key :sentences, :users, column: :sentence_user_id, primary_key: :user_id,
                                          name: 'fk_sentences_users_sentence_user_id'
    end

    # インデックスを更新
    remove_index :sentences, :user_id if index_exists?(:sentences, :user_id)

    return if index_exists?(:sentences, :sentence_user_id)

    add_index :sentences, :sentence_user_id
  end
end
