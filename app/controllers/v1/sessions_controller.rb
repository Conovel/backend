# frozen_string_literal: true

module V1
  # SessionsController
  class SessionsController < ApplicationController
    # ApplicationControllerのauthenticate_requestをスキップ
    skip_before_action :authenticate_request, only: [:create]

    # rubocop:disable Metrics/AbcSize
    def create
      frontend_url = ENV.fetch('REACT_APP_API_URL', nil)
      user_info = request.env['omniauth.auth']
      google_user_id = user_info['uid']
      provider = user_info['provider']
      token = generate_token_with_google_user_id(google_user_id, provider)

      user_authentication = UserAuthentication.find_by(uid: google_user_id, provider:)

      if user_authentication
        Rails.logger.info('アプリユーザー登録されている')
      else
        Rails.logger.info('まだアプリユーザー登録されていない')
        # ユーザーを作成(カラムはアプリの内容によって変更する)
        user = User.create(nickname: '新規ユーザー', achievement: 0, current_avatar_url: '/default/default_player.png')
        UserAuthentication.create(user_id: user.id, uid: google_user_id, provider:)
      end
      redirect_to "#{frontend_url}/MyPage?token=#{token}", allow_other_host: true
    end
    # rubocop:enable Metrics/AbcSize

    private

    def generate_token_with_google_user_id(google_user_id, provider)
      exp = Time.now.to_i + (24 * 3600)
      payload = { google_user_id:, provider:, exp: }
      hmac_secret = ENV.fetch('JWT_SECRET_KEY', nil)
      JWT.encode(payload, hmac_secret, 'HS256')
    end
  end
end
