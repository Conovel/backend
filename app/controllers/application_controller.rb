# frozen_string_literal: true

# ApplicationController
# 全てのコントローラーの基底クラス
class ApplicationController < ActionController::API
  include ErrorResponseHelper
  include ActionController::Cookies

  # authenticate_requestをスキップ
  before_action :authenticate_request

  # カレントユーザーを返す
  attr_reader :current_user_id

  # 任意の例外を補足
  rescue_from StandardError, with: :handle_standard_error
  rescue_from ArgumentError, with: :handle_argument_error
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from CustomError, with: :handle_custom_error

  private

  # 必須認証（失敗したら401を返す）
  def authenticate_request
    set_current_user_id_from_jwt
    return if @current_user_id

    reset_jwt_auth_state
    render_error_response(401, '認証に失敗しました')
    Rails.logger.debug('[DEBUG] authenticate_request: 必須認証を実行')
  end

  # 任意認証（失敗しても401にしない）
  def try_authenticate_request
    set_current_user_id_from_jwt
    return if @current_user_id

    reset_jwt_auth_state
    Rails.logger.debug('[DEBUG] try_authenticate_request: 任意認証を実行')
  end

  # クッキーからJWTトークンを取得
  # rubocop:disable Metrics/AbcSize
  def set_current_user_id_from_jwt
    jwt_token = cookies[:jwt_token]
    Rails.logger.debug("[DEBUG] cookies[:jwt_token].to_json(処理前): #{cookies[:jwt_token].to_json}")
    return unless jwt_token.present?

    begin
      @decoded = JwtService.decode(jwt_token)
      Rails.logger.debug("[DEBUG] トークン - token: #{jwt_token}")
      Rails.logger.debug("[DEBUG] デコード - decoded: #{@decoded}")
      @current_user_id = @decoded['user_id']
      Rails.logger.debug("[DEBUG] カレントユーザー - @current_user_id: #{@current_user_id.to_json}")
      nil
    rescue JWT::ExpiredSignature
      Rails.logger.warn('[WARN] JWTトークンの有効期限が切れています')
    rescue JWT::DecodeError => e
      Rails.logger.error("[ERROR] JWTデコードエラー - e.message: #{e.message}")
    end
  end
  # rubocop:enable Metrics/AbcSize

  # JWTトークンを保存しているクッキーを削除
  def reset_jwt_auth_state
    cookies.delete(:jwt_token)
    Rails.logger.info('[INFO] JWTトークンがクッキーから削除されました')
    Rails.logger.debug("[DEBUG] cookies[:jwt_token].to_json: #{cookies[:jwt_token].to_json}")
    @current_user_id = nil
    Rails.logger.debug("[DEBUG] カレントユーザー - @current_user_id: #{@current_user_id.to_json}")
  end

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
