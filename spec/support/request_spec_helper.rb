# frozen_string_literal: true

module RequestSpecHelper
  # JSONレスポンスをパースするメソッド
  def json
    JSON.parse(response.body)
  end
end
