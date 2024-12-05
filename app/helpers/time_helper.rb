# frozen_string_literal: true

# TimeHelper
module TimeHelper
  # 時刻をフォーマット（日本時間）
  def format_time(time)
    time.in_time_zone('Asia/Tokyo')
  end
end
