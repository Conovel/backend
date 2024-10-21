# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# 既存のシードデータを削除
Sentence.delete_all

# オートインクリメント値をリセット
ActiveRecord::Base.connection.execute('ALTER TABLE sentences AUTO_INCREMENT = 1')

sentences = [
  { text: '吾輩は猫である。', sentence_hierarchy: 1 },
  { text: '名前はまだない。', sentence_hierarchy: 2 },
  { text: 'どこで生れたかとんと見当がつかぬ。', sentence_hierarchy: 3 },
  { text: '何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。', sentence_hierarchy: 4 }
]

# 新しいシードデータを挿入（日本時間 & 0.1秒ずらす）
sentences.each do |sentence|
  japan_time = Time.now.in_time_zone('Asia/Tokyo')
  Sentence.create(
    sentence: sentence[:text],
    sentence_hierarchy: sentence[:sentence_hierarchy],
    created_at: japan_time,
    updated_at: japan_time
  )
  sleep(0.1)
end
