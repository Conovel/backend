# frozen_string_literal: true

# Title model handles the titles in the application.
class Title < ApplicationRecord
  # アソシエーション
  belongs_to :author_user, class_name: 'User'

  # バリデーション
  validates :author_user_id, presence: true
  validates :title, presence: true, length: { maximum: 128 }
  validates :is_permission_violence, inclusion: { in: [true, false] }
  validates :is_permission_adult, inclusion: { in: [true, false] }
  validates :main_copy, presence: true
end
