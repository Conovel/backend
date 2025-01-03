# frozen_string_literal: true

# ApplicationController
# 全てのコントローラーの基底クラス
class ApplicationController < ActionController::API
  # 仮のcurrent_userメソッド
  def current_user
    # 仮のユーザーオブジェクトを返す
    Struct.new(:id).new(2) # 仮のユーザーIDを2とする
  end

  # Google認証実装後のcurrent_userメソッド
  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end
end
