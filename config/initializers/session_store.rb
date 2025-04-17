# frozen_string_literal: true

# セッションストアの初期化
Rails.application.config.session_store :cookie_store, key: ENV.fetch('SESSION_KEY', '_your_app_session'),
                                                      expire_after: SESSION_EXPIRATION_TIME
