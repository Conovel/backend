# frozen_string_literal: true

module RequestSpecHelper
  # JSONレスポンスをパースするメソッド
  def json
    JSON.parse(response.body)
  end

  # Authorizationヘッダーを生成するメソッド
  # デフォルトでユーザーIDを2に設定
  def auth_headers(user_id = 2)
    token = JwtService.encode({ user_id: })
    { 'Authorization' => "Bearer #{token}" }
  end
end
