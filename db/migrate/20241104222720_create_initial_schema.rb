# frozen_string_literal: true

# データベースの初期スキーマを定義するマイグレーションファイル
class CreateInitialSchema < ActiveRecord::Migration[7.0]
  def change
    create_sentences_table
    create_titles_table
    create_users_table
    create_evaluations_table
    create_genres_table
    create_title_genres_table
    add_foreign_keys
    add_indexes
  end

  private

  # sentencesテーブル
  def create_sentences_table
    create_table 'sentences', primary_key: 'sentence_id', charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                              force: :cascade do |t|
      add_sentence_columns(t)
      t.timestamps
    end
  end

  def add_sentence_columns(table)
    table.bigint 'sentence_user_id', null: false
    table.mediumtext 'sentence', null: false
    table.bigint 'parent_sentence_id'
    table.bigint 'title_id', null: false
    table.integer 'sentence_hierarchy', null: false
    table.datetime 'deleted_at'
  end

  # titlesテーブル
  def create_titles_table
    create_table 'titles', primary_key: 'title_id', charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                           force: :cascade do |t|
      add_titles_columns(t)
      t.timestamps
    end
  end

  def add_titles_columns(table)
    table.bigint 'author_user_id', null: false
    table.string 'title', limit: 128, default: '未定', null: false
    table.boolean 'is_permission_violence', null: false
    table.boolean 'is_permission_adult', null: false
    table.text 'main_copy', null: false
    table.text 'overview'
    table.datetime 'deleted_at'
  end

  # usersテーブル
  def create_users_table
    create_table 'users', primary_key: 'user_id', charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                          force: :cascade do |t|
      add_users_columns(t)
      t.timestamps
    end
  end

  def add_users_columns(table)
    table.string 'pen_name', limit: 32, null: false
    table.string 'nick_name', limit: 32, null: false
    table.string 'birth_ym', limit: 6, null: false # dateだと8桁（YYYYMMDD）になるためstringの6桁（YYYYMM）にする
    table.integer 'agreed_terms_version', null: false, unsigned: true
    table.boolean 'is_anonymous', null: false
    table.text 'profile_icon_image', null: false
    table.string 'email', limit: 255, null: false # uniqueのindexを設定するために文字数制限が必要
    table.string 'google_sub', limit: 128, null: false
    table.text 'remarks'
    table.datetime 'deleted_at'
  end

  # evaluationsテーブル
  def create_evaluations_table
    create_table 'evaluations', id: false, charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                                force: :cascade do |t|
      add_evaluations_columns(t)
      t.timestamps
    end

    # 複合主キーを設定(SQLのALTER TABLE文)
    execute 'ALTER TABLE evaluations ADD PRIMARY KEY (sentence_id, evaluator_user_id)'
  end

  def add_evaluations_columns(table)
    table.bigint 'sentence_id', null: false
    table.bigint 'evaluator_user_id', null: false
    table.integer 'evaluation', null: false # enem値はモデルで設定：{ good: 0, bad: 1, stay: 2 }
    table.datetime 'deleted_at'
  end

  # genresテーブル
  def create_genres_table
    create_table 'genres', primary_key: 'genre_id', charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                           force: :cascade do |t|
      add_genres_columns(t)
      t.timestamps
    end
  end

  def add_genres_columns(table)
    table.string 'genre_name', limit: 16, null: false
    table.datetime 'deleted_at'
  end

  # title_genresテーブル
  def create_title_genres_table
    create_table 'title_genres', id: false, charset: 'utf8mb4', collation: 'utf8mb4_general_ci', force: :cascade do |t|
      add_title_genres_columns(t)
      t.timestamps
    end

    # 複合主キーを設定(SQLのALTER TABLE文)
    execute 'ALTER TABLE title_genres ADD PRIMARY KEY (title_id, genre_id)'
  end

  def add_title_genres_columns(table)
    table.bigint 'title_id', null: false
    table.bigint 'genre_id', null: false
    table.datetime 'deleted_at'
  end

  # 外部キー制約を追加
  def add_foreign_keys
    add_foreign_key :sentences, :sentences, column: :parent_sentence_id, primary_key: :sentence_id
    add_foreign_key :sentences, :titles, column: :title_id, primary_key: :title_id
    add_foreign_key :sentences, :users, column: :sentence_user_id, primary_key: :user_id
    add_foreign_key :titles, :users, column: :author_user_id, primary_key: :user_id
    add_foreign_key :evaluations, :sentences, column: :sentence_id, primary_key: :sentence_id
    add_foreign_key :evaluations, :users, column: :evaluator_user_id, primary_key: :user_id
    add_foreign_key :title_genres, :titles, column: :title_id, primary_key: :title_id
    add_foreign_key :title_genres, :genres, column: :genre_id, primary_key: :genre_id
  end

  # インデックスを追加
  def add_indexes
    add_index :sentences, :deleted_at
    add_index :sentences, :parent_sentence_id
    add_index :sentences, :sentence_user_id
    add_index :sentences, :title_id, name: 'index_sentences_on_title_id'
    add_index :titles, :author_user_id, name: 'index_titles_on_author_user_id'
    add_index :titles, :deleted_at
    add_index :users, :email, unique: true
    add_index :users, :google_sub, unique: true
    add_index :users, :deleted_at
    add_index :evaluations, %i[sentence_id evaluator_user_id], unique: true
    add_index :evaluations, :deleted_at
    add_index :title_genres, %i[title_id genre_id], unique: true
  end
end
