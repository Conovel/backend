# frozen_string_literal: true

require 'open-uri'
require 'base64'

# ImageHelper
module ImageHelper
  # URLから画像を取得し、BASE64文字列に変換する
  def fetch_image_as_base64(image_url, profile_icon_image = 'no_image')
    ImageFetcherService.fetch_as_base64(image_url, profile_icon_image)
  end
end
