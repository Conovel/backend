# frozen_string_literal: true

# ViewedSentence model handles the viewed_sentences in the application.
class ViewedSentence < ApplicationRecord
  # 論理削除
  acts_as_paranoid

  # 複合主キー
  self.primary_keys = :viewed_sentence_id, :viewed_user_id

  # アソシエーション
  belongs_to :sentence, foreign_key: :viewed_sentence_id
  belongs_to :user, foreign_key: :viewed_user_id
end
