# frozen_string_literal: true

require 'open-uri'
require 'base64'

# ImageHelper
module ImageHelper
  # rubocop:disable Metrics/AbcSize
  # URLから画像を取得し、BASE64文字列に変換する
  def fetch_image_as_base64(image_url, profile_icon_image = 'no_image')
    return profile_icon_image if image_url.blank?

    begin
      uri = URI.parse(image_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https') # HTTPSの場合はSSLを有効にする
      http.open_timeout = TIMEOUT_SECONDS # 接続タイムアウト
      http.read_timeout = TIMEOUT_SECONDS # 読み込みタイムアウト

      response = http.get(uri.request_uri)
      if response.is_a?(Net::HTTPSuccess)
        content_type = response['Content-Type'] || 'image/jpeg'
        base64_data = Base64.strict_encode64(response.body)
        "data:#{content_type};base64,#{base64_data}"
      else
        profile_icon_image # HTTPリクエストが失敗した場合のデフォルト値
      end
    rescue StandardError => e
      Rails.logger.error("[ERROR] 画像の取得またはBASE64変換に失敗しました: #{e.message}")
      default_value
    end
  end
  # rubocop:enable Metrics/AbcSize
end
