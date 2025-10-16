# frozen_string_literal: true

require 'omniauth'
require 'omniauth-google-oauth2'

OmniAuth.config.test_mode = true
# GET も許可（OmniAuth 2.x はデフォルト POST のため）
OmniAuth.config.allowed_request_methods = %i[get post]

OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
  provider: 'google_oauth2',
  uid: '123456789',
  info: {
    email: 'test@example.com',
    image: 'https://example.com/avatar.png'
  }
)
