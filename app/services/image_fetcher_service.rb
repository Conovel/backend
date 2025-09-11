# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'base64'

# ImageFetcherService
# Service to fetch remote images and return a base64 data URI or a fallback value.
class ImageFetcherService
  TIMEOUT_SECONDS = 5

  # rubocop:disable Metrics/AbcSize
  def self.fetch_as_base64(image_url, fallback = 'no_image')
    return fallback if image_url.blank?

    uri = URI.parse(image_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    http.open_timeout = TIMEOUT_SECONDS
    http.read_timeout = TIMEOUT_SECONDS

    response = http.get(uri.request_uri)
    if response.is_a?(Net::HTTPSuccess)
      content_type = response['Content-Type'] || 'image/jpeg'
      base64_data = Base64.strict_encode64(response.body)
      "data:#{content_type};base64,#{base64_data}"
    else
      fallback
    end
  rescue StandardError => e
    Rails.logger.error("[ERROR] ImageFetcherService.fetch_as_base64 failed: #{e.message}")
    fallback
  end
  # rubocop:enable Metrics/AbcSize
end
