# frozen_string_literal: true

# usersテーブルを作成
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, primary_key: :user_id, id: :bigint, charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                         force: :cascade do |t|
      t.string :pen_name, null: false, limit: 32
      t.timestamps
    end
  end
end
