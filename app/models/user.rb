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
  validates :pen_name, presence: true, length: { maximum: 32 }, uniqueness: { case_sensitive: false }
  validates :nick_name, presence: true, length: { maximum: 32 }, uniqueness: { case_sensitive: false }
  validates :birth_ym, presence: true, length: { is: 6 }
  validates :agreed_terms_version, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :is_anonymous, inclusion: { in: [true, false] }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :google_sub, presence: true, uniqueness: true, length: { maximum: 128 }
  validates :refresh_token, uniqueness: true, allow_nil: true

  # カスタムバリデーション
  validate :birth_ym_format_and_not_future
  validate :agreed_terms_version_not_exceed_latest
  validate :pen_and_nick_name_uniqueness_across_users

  # 利用規約の最新バージョン
  LATEST_TERMS_VERSION = ENV.fetch('LATEST_TERMS_VERSION', 1).to_i

  # リフレッシュトークンを生成
  def generate_refresh_token
    token = SecureRandom.hex(64)
    self.refresh_token = Digest::SHA256.hexdigest(token)
    save!
    token
  end

  # リフレッシュトークンの値を検証
  def valid_refresh_token_value?(token)
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
  def valid_refresh_token_expiry?(api_execution_date)
    Rails.logger.debug("[DEBUG] ユーザーID#{id}のリフレッシュトークンの有効期限: #{refresh_token_expires_at.to_json}")

    if refresh_token_expires_at.present? && refresh_token_expires_at < api_execution_date
      update!(refresh_token: nil, refresh_token_expires_at: nil)
      Rails.logger.info("[INFO] ユーザーID#{id}の期限切れリフレッシュトークンを削除しました")
      false # トークンは無効
    else
      Rails.logger.info("[INFO] ユーザーID#{id}の期限切れリフレッシュトークンはありませんでした")
      true # トークンは有効
    end
  end

  # サフィックス付与によるユニークなユーザー名生成
  def self.generate_unique_user_name(base_name)
    name = base_name
    suffix = 1
    Rails.logger.debug("[generate_unique_user_name] 初期名: #{name}（サフィックス: #{suffix}）")
    while User.where(deleted_at: nil)
              .where('pen_name = ? OR nick_name = ?', name, name)
              .exists?
      Rails.logger.debug("[generate_unique_user_name] 重複検出: #{name}（サフィックス: #{suffix}）")
      name = "#{base_name}-#{suffix}"
      suffix += 1
    end
    Rails.logger.debug("[generate_unique_user_name] ユニーク名決定: #{name}")
    name
  end

  private

  # birth_ymが正しい形式かどうかを検証し、エラーを追加する
  def birth_ym_format_and_not_future
    return if birth_ym.blank?
    return add_birth_ym_format_error unless valid_birth_ym_format?
    return add_birth_ym_month_error unless valid_birth_ym_month?
    return add_birth_ym_date_error unless valid_birth_ym_date?

    add_birth_ym_future_error if birth_ym_in_future?
  end

  # birth_ymがYYYYMM形式かどうかを判定する
  def valid_birth_ym_format?
    birth_ym.match?(/\A\d{6}\z/)
  end

  # birth_ymの月部分が01〜12かどうかを判定する
  def valid_birth_ym_month?
    month = birth_ym[4..5].to_i
    (1..12).include?(month)
  end

  # birth_ymが実在する年月かどうかを判定する
  def valid_birth_ym_date?
    year = birth_ym[0..3].to_i
    month = birth_ym[4..5].to_i
    begin
      Date.new(year, month, 1)
    rescue StandardError
      false
    end
  end

  # birth_ymが未来日かどうかを判定する
  def birth_ym_in_future?
    year = birth_ym[0..3].to_i
    month = birth_ym[4..5].to_i
    ym_date = begin
      Date.new(year, month, 1)
    rescue StandardError
      nil
    end
    ym_date && ym_date > Date.today.beginning_of_month
  end

  # birth_ymの形式エラーを追加する
  def add_birth_ym_format_error
    errors.add(:birth_ym, 'はYYYYMM形式で入力してください')
  end

  # birth_ymの月エラーを追加する
  def add_birth_ym_month_error
    errors.add(:birth_ym, 'の月は01〜12で入力してください')
  end

  # birth_ymの日付エラーを追加する
  def add_birth_ym_date_error
    errors.add(:birth_ym, 'が不正です')
  end

  # birth_ymが未来日の場合のエラーを追加する
  def add_birth_ym_future_error
    errors.add(:birth_ym, 'は未来の日付を指定できません')
  end

  # agreed_terms_versionが最新バージョンを超えていないか検証する
  def agreed_terms_version_not_exceed_latest
    return if agreed_terms_version.blank?

    return unless agreed_terms_version > LATEST_TERMS_VERSION

    errors.add(:agreed_terms_version, "は最新バージョン(#{LATEST_TERMS_VERSION})を超えています")
  end

  # pen_name/nick_nameが他ユーザーと重複していないか検証する
  # rubocop:disable Metrics/AbcSize
  def pen_and_nick_name_uniqueness_across_users
    return if deleted_at.present?
    return if pen_name.blank? && nick_name.blank?

    conflict = User.where.not(user_id:)
                   .where(deleted_at: nil)
                   .where('pen_name = ? OR nick_name = ? OR pen_name = ? OR nick_name = ?',
                          pen_name, pen_name, nick_name, nick_name)
                   .exists?
    return unless conflict

    errors.add(:base, 'pen_nameまたはnick_nameが他のユーザーと重複しています')
  end
  # rubocop:enable Metrics/AbcSize
end
