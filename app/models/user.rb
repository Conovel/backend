# frozen_string_literal: true

# User model handles the users in the application.
class User < ApplicationRecord
  # 論理削除
  acts_as_paranoid

  # アソシエーション
  has_many :titles, foreign_key: 'author_user_id'
  has_many :sentences, foreign_key: 'sentence_user_id'
  has_many :evaluations, foreign_key: 'evaluator_user_id'

  # バリデーション
  validates :pen_name, presence: true, length: { maximum: 32 }
  validates :nick_name, presence: true, length: { maximum: 32 }
  validates :birth_ym, presence: true, length: { is: 6 }
  validates :agreed_terms_version, presence: true, numericality: { only_integer: true }
  validates :is_anonymous, inclusion: { in: [true, false] }
  validates :profile_icon_image, presence: true
  validates :email, presence: true, uniqueness: true
  validates :google_sub, presence: true, uniqueness: true, length: { maximum: 128 }
  validates :refresh_token, uniqueness: true, allow_nil: true

  # リフレッシュトークンを生成
  def generate_refresh_token
    token = SecureRandom.hex(64)
    self.refresh_token = Digest::SHA256.hexdigest(token)
    save!
    token
  end

  # リフレッシュトークンを検証
  def valid_refresh_token?(token)
    return false if refresh_token.blank? || token.blank?

    ActiveSupport::SecurityUtils.secure_compare(
      refresh_token,
      Digest::SHA256.hexdigest(token)
    )
  end

  # リフレッシュトークンを無効化
  def invalidate_refresh_token
    self.refresh_token = nil
    save!
  end

  # リフレッシュトークンが期限切れの場合はnilに設定
  def self.cleanup_expired_refresh_tokens
    expiration_date = 1.month.ago
    where('refresh_token_created_at < ?', expiration_date).update_all(refresh_token: nil, refresh_token_created_at: nil)
    Rails.logger.info('[INFO] Expired refresh tokens have been cleaned up.')
  end
end
