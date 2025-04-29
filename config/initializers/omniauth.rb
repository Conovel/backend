# frozen_string_literal: true

# RailsアプリケーションのミドルウェアスタックにOmniAuthビルダーを追加する
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV.fetch('GOOGLE_CLIENT_ID', nil),
           ENV.fetch('GOOGLE_CLIENT_SECRET', nil),
           {
             scope: 'email profile',
             prompt: 'select_account',
             skip_jwt: true
           }
  OmniAuth.config.allowed_request_methods = %i[post get]
end

# OmniAuth のエラー処理をカスタマイズ
OmniAuth.config.on_failure = proc do |env|
  V1::AuthController.action(:auth_failure).call(env)
end
