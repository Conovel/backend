# frozen_string_literal: true

# sentencesテーブルにuser_idカラムを再追加 (エラーがおこらないように修正)
# エラーの理由:
# 既存のsentencesテーブルにuser_idカラムを追加する際に、外部キー制約が原因でマイグレーションが失敗した。
# 既存のレコードに対してuser_idがnullを許容しないために発生した。
# そのため、既存のuser_idカラムを削除し、再度追加する処理を行った。
class AddUserIdToSentencesRetry < ActiveRecord::Migration[7.0]
  # Userモデルをロード
  class User < ActiveRecord::Base; end
  class Sentence < ActiveRecord::Base; end

  def change
    remove_existing_user_id_column if column_exists?(:sentences, :user_id)
    add_user_id_column
    set_default_user_id
    make_user_id_non_nullable
    add_foreign_key_and_index
  end

  # マイグレーションは成功したが、Rubocopにメソッド内の行数が多いと警告されたため、メソッドを分割した。

  private

  def remove_existing_user_id_column
    # 既にuser_idカラムが存在する場合は削除
    remove_foreign_key :sentences, column: :user_id if foreign_key_exists?(:sentences, column: :user_id)
    remove_column :sentences, :user_id
  end

  def add_user_id_column
    # user_idカラムを追加（null許容）
    add_column :sentences, :user_id, :bigint, null: true
  end

  def set_default_user_id
    # デフォルトのユーザーを作成し、そのIDを取得
    default_user = User.first_or_create!(pen_name: 'default_user')
    default_user_id = default_user.id
    # 既存のレコードにデフォルトのuser_idを設定
    Sentence.update_all(user_id: default_user_id)
  end

  def make_user_id_non_nullable
    # user_idカラムをnull: falseに変更
    change_column_null :sentences, :user_id, false
  end

  def add_foreign_key_and_index
    # 外部キー制約を追加
    add_foreign_key :sentences, :users, column: :user_id, primary_key: :user_id
    # インデックスを追加
    add_index :sentences, :user_id
  end
end
