# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_241_104_222_720) do
  create_table 'evaluations', primary_key: %w[sentence_id evaluator_user_id], charset: 'utf8mb4',
                              collation: 'utf8mb4_general_ci', force: :cascade do |t|
    t.bigint 'sentence_id', null: false
    t.bigint 'evaluator_user_id', null: false
    t.integer 'evaluation', null: false
    t.datetime 'deleted_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['deleted_at'], name: 'index_evaluations_on_deleted_at'
    t.index ['evaluator_user_id'], name: 'fk_rails_62490f0cce'
    t.index %w[sentence_id evaluator_user_id], name: 'index_evaluations_on_sentence_id_and_evaluator_user_id',
                                               unique: true
    t.index ['sentence_id'], name: 'index_evaluations_on_sentence_id'
  end

  create_table 'genres', primary_key: 'genre_id', charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                         force: :cascade do |t|
    t.string 'genre_name', limit: 16, null: false
    t.datetime 'deleted_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'sentences', primary_key: 'sentence_id', charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                            force: :cascade do |t|
    t.bigint 'sentence_user_id', null: false
    t.text 'sentence', size: :medium, null: false
    t.bigint 'parent_sentence_id'
    t.bigint 'title_id', null: false
    t.integer 'sentence_hierarchy', null: false
    t.datetime 'deleted_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'viewed_sentences_count', default: 0, null: false
    t.index ['deleted_at'], name: 'index_sentences_on_deleted_at'
    t.index ['parent_sentence_id'], name: 'index_sentences_on_parent_sentence_id'
    t.index ['sentence_id'], name: 'index_sentences_on_sentence_id'
    t.index ['sentence_user_id'], name: 'index_sentences_on_sentence_user_id'
    t.index ['title_id'], name: 'index_sentences_on_title_id'
  end

  create_table 'title_genres', primary_key: %w[title_id genre_id], charset: 'utf8mb4',
                               collation: 'utf8mb4_general_ci', force: :cascade do |t|
    t.bigint 'title_id', null: false
    t.bigint 'genre_id', null: false
    t.datetime 'deleted_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['genre_id'], name: 'fk_rails_02cc8fcde9'
    t.index %w[title_id genre_id], name: 'index_title_genres_on_title_id_and_genre_id', unique: true
  end

  create_table 'titles', primary_key: 'title_id', charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                         force: :cascade do |t|
    t.bigint 'author_user_id', null: false
    t.string 'title', limit: 128, default: '未定', null: false
    t.boolean 'is_permission_violence', null: false
    t.boolean 'is_permission_adult', null: false
    t.text 'main_copy', null: false
    t.text 'overview'
    t.datetime 'deleted_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['author_user_id'], name: 'index_titles_on_author_user_id'
    t.index ['deleted_at'], name: 'index_titles_on_deleted_at'
  end

  create_table 'users', primary_key: 'user_id', charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                        force: :cascade do |t|
    t.string 'pen_name', limit: 32, null: false
    t.string 'nick_name', limit: 32, null: false
    t.string 'birth_ym', limit: 6, null: false
    t.integer 'agreed_terms_version', null: false, unsigned: true
    t.boolean 'is_anonymous', null: false
    t.text 'profile_icon_image', null: false
    t.string 'email', null: false
    t.string 'google_sub', limit: 128, null: false
    t.text 'remarks'
    t.string 'refresh_token'
    t.datetime 'refresh_token_expires_at'
    t.datetime 'deleted_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['deleted_at'], name: 'index_users_on_deleted_at'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['google_sub'], name: 'index_users_on_google_sub', unique: true
    t.index ['refresh_token'], name: 'index_users_on_refresh_token', unique: true
  end

  create_table 'viewed_sentences', primary_key: %w[viewed_sentence_id viewed_user_id], charset: 'utf8mb4',
                                   collation: 'utf8mb4_general_ci', force: :cascade do |t|
    t.bigint 'viewed_sentence_id', null: false
    t.bigint 'viewed_user_id', null: false
    t.datetime 'viewed_at', null: false
    t.datetime 'deleted_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['deleted_at'], name: 'index_viewed_sentences_on_deleted_at'
    t.index %w[viewed_sentence_id viewed_user_id],
            name: 'index_viewed_sentences_on_viewed_sentence_id_and_viewed_user_id', unique: true
    t.index ['viewed_user_id'], name: 'fk_rails_3a3fe98794'
  end

  add_foreign_key 'evaluations', 'sentences', primary_key: 'sentence_id'
  add_foreign_key 'evaluations', 'users', column: 'evaluator_user_id', primary_key: 'user_id'
  add_foreign_key 'sentences', 'sentences', column: 'parent_sentence_id', primary_key: 'sentence_id'
  add_foreign_key 'sentences', 'titles', primary_key: 'title_id'
  add_foreign_key 'sentences', 'users', column: 'sentence_user_id', primary_key: 'user_id'
  add_foreign_key 'title_genres', 'genres', primary_key: 'genre_id'
  add_foreign_key 'title_genres', 'titles', primary_key: 'title_id'
  add_foreign_key 'titles', 'users', column: 'author_user_id', primary_key: 'user_id'
  add_foreign_key 'viewed_sentences', 'sentences', column: 'viewed_sentence_id', primary_key: 'sentence_id'
  add_foreign_key 'viewed_sentences', 'users', column: 'viewed_user_id', primary_key: 'user_id'
end
