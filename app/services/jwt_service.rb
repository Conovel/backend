# frozen_string_literal: true

# JwtService
class JwtService
  # トークンをデコードする
  def self.decode(token)
    hmac_secret = ENV.fetch('JWT_SECRET_KEY', nil)
    JWT.decode(token, hmac_secret, true, { algorithm: 'HS256' }).first
  end

  # トークンをエンコードする
  def self.encode(payload, exp = 24.hours.from_now)
    hmac_secret = ENV.fetch('JWT_SECRET_KEY', nil)
    payload[:exp] = exp.to_i
    JWT.encode(payload, hmac_secret, 'HS256')
  end
end
