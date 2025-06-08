# frozen_string_literal: true

# TimeHelper
module TimeHelper
  # 時刻をフォーマット（日本時間）
  def format_time(time = Time.zone.now)
    time.in_time_zone('Asia/Tokyo')
  end

  # 時刻をフォーマット（日本時間）して文字列として返す
  def format_time_with_strftime(time = Time.zone.now)
    format_time(time).strftime('%Y-%m-%d %H:%M:%S %z')
  end

  # テキストを時刻にしてからフォーマット（日本時間）
  def format_time_from_string(time_str)
    format_time(DateTime.parse(time_str))
  end

  # テキストを時刻にしてからフォーマット（日本時間）して文字列として返す
  def format_time_from_string_with_strftime(time_str)
    format_time(DateTime.parse(time_str)).strftime('%Y-%m-%d %H:%M:%S %z')
  end

  # 時刻をフォーマット（日本時間）して年月（例: "202406"）を返す
  def format_year_month(time = Time.zone.now)
    format_time(time).strftime('%Y%m')
  end
end
