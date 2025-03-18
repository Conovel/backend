# frozen_string_literal: true

# ApplicationController
# 全てのコントローラーの基底クラス
class ApplicationController < ActionController::API
  before_action :authenticate_request
  include ErrorResponseHelper

  # カレントユーザーを返す
  attr_reader :current_user

  # 仮のユーザーオブジェクトを返す（最終的には削除）
  # def current_user
  #   Struct.new(:id).new(2) # 仮のユーザーIDを2とする
  # end

  # Google認証実装後のcurrent_userメソッド
  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end

  # 任意の例外を補足
  rescue_from StandardError, with: :handle_standard_error
  rescue_from ArgumentError, with: :handle_argument_error
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from CustomError, with: :handle_custom_error

  private

  # リクエストの認証
  # rubocop:disable Metrics/AbcSize
  def authenticate_request
    token = request.headers['Authorization']
    token = token.split.last if token
    begin
      @decoded = JwtService.decode(token)
      Rails.logger.info("[INFO]トークン - token: #{token}")
      Rails.logger.info("[INFO]デコード - decorded: #{@decoded}")

      if @decoded['user_id'] == '2' # 仮の条件

        @current_user = User.find(@decoded['user_id']) # TODO：ここを作り込みたい
      else
        # user_auth = UserAuthentication.find_by(uid: @decoded['google_user_id'], provider: @decoded['provider'])
        # @current_user = user_auth.user if user_auth

        # 仮のユーザーオブジェクトを返す
        @current_user = Struct.new(:id).new(2) # 仮のユーザーIDを2を返す
      end
      Rails.logger.info("[INFO]カレントユーザー - @current_user: #{@current_user}")
      raise ActiveRecord::RecordNotFound, 'User not found' unless @current_user
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      Rails.logger.error("[ERROR]認証エラー - e.message: #{e.message}")
      render json: { errors: e.message }, status: :unauthorized
    end
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
