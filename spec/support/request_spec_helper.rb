# frozen_string_literal: true

module RequestSpecHelper
  # JSONレスポンスをパースするメソッド
  def json
    JSON.parse(response.body)
  end

  # ログインユーザーとしてリクエストを送信するメソッド
  def login_as(user)
    cookies[:jwt_token] = JwtService.encode(user_id: user.id)
    get '/v1/novels'
  end
end
