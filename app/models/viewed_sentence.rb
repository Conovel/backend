# frozen_string_literal: true

# ViewedSentence model handles the viewed_sentences in the application.
class ViewedSentence < ApplicationRecord
  # 論理削除
  acts_as_paranoid

  # 複合主キー
  self.primary_keys = :viewed_sentence_id, :viewed_user_id

  # アソシエーション
  belongs_to :sentence, foreign_key: :viewed_sentence_id, counter_cache: true
  belongs_to :user, foreign_key: :viewed_user_id

  # カウンターキャッシュの更新
  after_destroy :update_counter_cache
  after_restore :update_counter_cache

  private

  def update_counter_cache
    Sentence.reset_counters(viewed_sentence_id, :viewed_sentences)
  end
end
