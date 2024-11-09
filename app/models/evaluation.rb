# frozen_string_literal: true

# evaluation model handles the evaluations in the application.
class Evaluation < ApplicationRecord
  # 複合主キー
  self.primary_keys = :sentence_id, :evaluator_user_id

  # アソシエーション
  belongs_to :sentence
  belongs_to :evaluator_user, class_name: 'User'

  # enumの設定
  enum evaluation: { good: 0, bad: 1, stay: 2 }

  # バリデーション
  validates :sentence_id, presence: true
  validates :evaluator_user_id, presence: true
  validates :evaluation, presence: true, inclusion: { in: Evaluation.evaluations.keys }
end
