# frozen_string_literal: true

# JwtService
class JwtService
  def self.decode(token)
    hmac_secret = ENV.fetch('JWT_SECRET_KEY', nil)
    JWT.decode(token, hmac_secret, true, { algorithm: 'HS256' }).first
  end
end
