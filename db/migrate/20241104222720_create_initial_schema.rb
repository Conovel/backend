# frozen_string_literal: true

# データベースの初期スキーマを定義するマイグレーションファイル
class CreateInitialSchema < ActiveRecord::Migration[7.0]
  def change
    create_sentences_table
    create_titles_table
    create_users_table
    add_foreign_keys
  end

  private

  def create_sentences_table
    create_table 'sentences', primary_key: 'sentence_id', charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                              force: :cascade do |t|
      add_sentence_columns(t)
      t.timestamps
    end
    add_sentences_indexes
  end

  def add_sentence_columns(table)
    table.mediumtext 'sentence', null: false
    table.integer 'sentence_hierarchy', null: false
    table.bigint 'title_id', null: false
    table.bigint 'sentence_user_id', null: false
    table.bigint 'parent_sentence_id'
    table.datetime 'deleted_at'
  end

  def add_sentences_indexes
    add_index :sentences, :deleted_at
    add_index :sentences, :parent_sentence_id
    add_index :sentences, :sentence_user_id
    add_index :sentences, :title_id
  end

  def create_titles_table
    create_table 'titles', primary_key: 'title_id', charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                           force: :cascade do |t|
      add_titles_columns(t)
      t.timestamps
    end
  end

  def add_titles_columns(table)
    table.string 'title', limit: 128, default: '未定', null: false
    table.boolean 'is_permission_violence', null: false
    table.boolean 'is_permission_adult', null: false
    table.text 'main_copy', null: false
    table.text 'overview'
    table.datetime 'deleted_at'
  end

  def create_users_table
    create_table 'users', primary_key: 'user_id', charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                          force: :cascade do |t|
      add_users_columns(t)
      t.timestamps
    end
  end

  def add_users_columns(table)
    table.string 'pen_name', limit: 32, null: false
  end

  def add_foreign_keys
    add_foreign_key :sentences, :sentences, column: :parent_sentence_id, primary_key: :sentence_id
    add_foreign_key :sentences, :titles, column: :title_id, primary_key: :title_id
    add_foreign_key :sentences, :users, column: :sentence_user_id, primary_key: :user_id
  end
end
