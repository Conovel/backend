# frozen_string_literal: true

# ApplicationController
# 全てのコントローラーの基底クラス
class ApplicationController < ActionController::API
  include ErrorResponseHelper

  # 仮のcurrent_userメソッド
  def current_user
    # 仮のユーザーオブジェクトを返す
    Struct.new(:id).new(2) # 仮のユーザーIDを2とする
  end

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
    render_error_response(422, record_invalid_message(exception))
  end

  # CustomError の場合
  def handle_custom_error(exception)
    Rails.logger.error "CustomError: #{exception.message}\n#{exception.backtrace.join("\n")}"
    render_error_response(exception.code, exception.message, data: exception.data)
  end

  # コントローラーごとにエラーメッセージを取得
  def record_invalid_message(exception)
    custom_record_invalid_message(exception)
  end

  # コントローラーごとにカスタムエラーメッセージを定義（抽象メソッド）
  def custom_record_invalid_message(exception)
    raise NotImplementedError, 'custom_record_invalid_messageメソッドが実装されていません'
  end
end
