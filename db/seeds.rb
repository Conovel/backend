# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# ※データベース構築に集中するため一時的にコメントアウト

# 既存のシードデータを削除
# ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 0')
# Sentence.delete_all
# ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 1')

# オートインクリメント値をリセット
# ActiveRecord::Base.connection.execute('ALTER TABLE sentences AUTO_INCREMENT = 1')

# sentences = [
#   { sentence: '吾輩は猫である。', sentence_hierarchy: 1, parent_sentence_id: nil, title_id: 1 },
#   { sentence: '名前はまだない。', sentence_hierarchy: 2, parent_sentence_id: 1, title_id: 1 },
#   { sentence: 'どこで生れたかとんと見当がつかぬ。', sentence_hierarchy: 3, parent_sentence_id: 2, title_id: 1 },
#   { sentence: '何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。', sentence_hierarchy: 4, parent_sentence_id: 3, title_id: 1 }
# ]

# 新しいシードデータを挿入（日本時間 & 0.1秒ずらす）
# sentences.each do |sentence|
#   japan_time = Time.now.in_time_zone('Asia/Tokyo')
#   Sentence.create(
#     sentence: sentence[:sentence],
#     sentence_hierarchy: sentence[:sentence_hierarchy],
#     parent_sentence_id: sentence[:parent_sentence_id],
#     title_id: sentence[:title_id],
#     created_at: japan_time,
#     updated_at: japan_time
#   )
#   sleep(0.1)
# end
