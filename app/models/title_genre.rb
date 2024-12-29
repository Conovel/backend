# frozen_string_literal: true

# TitleGenre model handles the title_genres in the application.
class TitleGenre < ApplicationRecord
  # 論理削除
  acts_as_paranoid

  # 複合主キー
  self.primary_keys = :title_id, :genre_id

  # アソシエーション
  belongs_to :title
  belongs_to :genre

  # バリデーション
  validates :title_id, presence: true
  validates :genre_id, presence: true
end
