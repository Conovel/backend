Rails.application.config.session_store :cookie_store, key: ENV.fetch('SESSION_KEY', nil), secure: Rails.env.production?
