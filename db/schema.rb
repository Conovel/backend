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

ActiveRecord::Schema[7.0].define(version: 20_241_021_224_452) do
  create_table 'sentences', primary_key: 'sentence_id', charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                            force: :cascade do |t|
    t.text 'sentence', size: :medium, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'sentence_hierarchy', null: false
    t.bigint 'parent_sentence_id', null: false
    t.index ['parent_sentence_id'], name: 'index_sentences_on_parent_sentence_id'
  end

  create_table 'titles', primary_key: 'title_id', charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                         force: :cascade do |t|
    t.string 'title', limit: 128, default: '未定', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'sentences', 'sentences', column: 'parent_sentence_id', primary_key: 'sentence_id'
end
