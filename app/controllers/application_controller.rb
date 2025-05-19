# frozen_string_literal: true

# ApplicationController
# 全てのコントローラーの基底クラス
class ApplicationController < ActionController::API
  before_action :authenticate_request
  include ErrorResponseHelper
  include ActionController::Cookies

  # カレントユーザーを返す
  attr_reader :current_user_id

  # 任意の例外を補足
  rescue_from StandardError, with: :handle_standard_error
  rescue_from ArgumentError, with: :handle_argument_error
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from CustomError, with: :handle_custom_error

  private

  # リクエストの認証
  # rubocop:disable Metrics/AbcSize
  def authenticate_request
    # クッキーからJWTトークンを取得
    jwt_token = cookies[:jwt_token]
    if jwt_token.present?
      begin
        @decoded = JwtService.decode(jwt_token)
        Rails.logger.debug("[DEBUG] トークン - token: #{jwt_token}")
        Rails.logger.debug("[DEBUG] デコード - decoded: #{@decoded}")

        @current_user_id = @decoded['user_id']
        Rails.logger.debug("[DEBUG] カレントユーザー - @current_user_id: #{@current_user_id.to_json}")
        return
      rescue JWT::ExpiredSignature
        Rails.logger.warn('[WARN] JWTトークンの有効期限が切れています')
      rescue JWT::DecodeError => e
        Rails.logger.error("[ERROR] JWTデコードエラー - e.message: #{e.message}")
      end
    end

    # JWTトークンを保存しているクッキーを削除
    cookies.delete(:jwt_token)
    Rails.logger.info('[INFO] JWTトークンがクッキーから削除されました')
    Rails.logger.debug("[DEBUG] cookies[:jwt_token].to_json: #{cookies[:jwt_token].to_json}")

    @current_user_id = nil
    Rails.logger.debug("[DEBUG] カレントユーザー - @current_user_id: #{@current_user_id.to_json}")

    # 認証エラーを返す
    # TODO：今は一律でエラーのjsonを返しているがここは未ログイン時の出し分けトリガーにしたい
    render_error_response(401, '認証に失敗しました')
  end
  # rubocop:enable Metrics/AbcSize

  # 標準的な例外の処理
  def handle_standard_error(exception)
    Rails.logger.error "StandardError: #{exception.message}\n#{exception.backtrace.join("\n")}"
    render_error_response(500, "サーバーエラーが発生しました。: #{exception.message}")
  end

  # ArgumentError の場合
  def handle_argument_error(exception)
    Rails.logger.error "ArgumentError: #{exception.message}\n#{exception.backtrace.join("\n")}"
    render_error_response(422, "無効な値が含まれていました。: #{exception.message}")
  end

  # RecordInvalid の場合
  def handle_record_invalid(exception)
    Rails.logger.error "RecordInvalid: #{exception.message}\n#{exception.backtrace.join("\n")}"
    render_error_response(422, custom_record_invalid_message(exception))
  end

  # CustomError の場合
  def handle_custom_error(exception)
    Rails.logger.error "CustomError: #{exception.message}\n#{exception.backtrace.join("\n")}"
    render_error_response(exception.code, exception.message, data: exception.data)
  end

  # コントローラーごとにカスタムエラーメッセージを定義（抽象メソッド）
  def custom_record_invalid_message(exception)
    raise NotImplementedError, 'custom_record_invalid_messageメソッドが実装されていません'
  end
end
