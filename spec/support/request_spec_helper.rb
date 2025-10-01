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

  # 汎用的に任意のコントローラの任意のメソッド呼び出し回数を計測するヘルパ
  # 例: counter = install_method_call_counter(controller: V1::NovelsController, method: :user_display_info)
  def install_method_call_counter(controller:, method:)
    counter = CallCounter.new
    allow_any_instance_of(controller)
      .to receive(method)
      .and_wrap_original do |original, *args, &block|
      counter.tick
      original.call(*args, &block)
    end
    counter
  end
end
