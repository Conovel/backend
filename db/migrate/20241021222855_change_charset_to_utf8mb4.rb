# frozen_string_literal: true

# テーブルの文字コードをutf8mb4に変更する
class ChangeCharsetToUtf8mb4 < ActiveRecord::Migration[7.0]
  def change
    execute 'ALTER TABLE sentences CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;'
    execute 'ALTER TABLE titles CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;'
  end
end
