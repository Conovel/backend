# 本番運用を前提に CookieStore を設定
Rails.application.config.session_store(
  :cookie_store,
  key: ENV.fetch('SESSION_KEY', nil),
  domain: "conovel.jp",   # サブドメイン運用なら :all も可
  same_site: :lax,        # 同一サイト内の遷移なら :lax でOK。異なるドメイン跨ぎなら :none + secure: true
  secure: Rails.env.production?,           # 本番 https のみ
  expire_after: 14.days
)
