# frozen_string_literal: true

# TimeHelper
module TimeHelper
  # 時刻を文字列として返す
  def time_with_strftime(time = Time.zone.now)
    time.strftime('%Y-%m-%d %H:%M:%S %z')
  end

  # テキストを時刻に変換して文字列として返す
  def time_from_string_with_strftime(time_str)
    DateTime.parse(time_str).strftime('%Y-%m-%d %H:%M:%S %z')
  end

  # 時刻を年月（例: "202406"）として返す
  def year_month(time = Time.zone.now)
    time.strftime('%Y%m')
  end
end
