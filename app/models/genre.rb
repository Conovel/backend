# frozen_string_literal: true

# Genre model handles the genres in the application.
class Genre < ApplicationRecord
  # 論理削除
  acts_as_paranoid

  # アソシエーション
  has_many :title_genres
  has_many :titles, through: :title_genres

  # バリデーション
  validates :genre_name, presence: true, length: { maximum: 16 }
end
