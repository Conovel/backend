# frozen_string_literal: true

# OmniAuth より前に Cookies/Session を必ず入れる
Rails.application.config.middleware.insert_before OmniAuth::Builder, ActionDispatch::Cookies
Rails.application.config.middleware.insert_before OmniAuth::Builder, ActionDispatch::Session::CookieStore,
  key: ENV.fetch('SESSION_KEY'),                      # 本番で必ず設定（例: _conovel_session）
  secure: Rails.env.production?

# RailsアプリケーションのミドルウェアスタックにOmniAuthビルダーを追加する
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV.fetch('GOOGLE_CLIENT_ID', nil),
           ENV.fetch('GOOGLE_CLIENT_SECRET', nil),
           {
             scope: 'email profile',
             prompt: 'select_account',
             skip_jwt: true,
             image_aspect_ratio: 'square',
             image_size: PROFILE_ICON_IMAGE_SIZE
           }
  OmniAuth.config.allowed_request_methods = %i[post get]
end

OmniAuth.config.path_prefix = "/v1/auth"

# OmniAuth のエラー処理をカスタマイズ
OmniAuth.config.on_failure = proc do |env|
  V1::AuthController.action(:auth_failure).call(env)
end
