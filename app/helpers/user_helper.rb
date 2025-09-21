# frozen_string_literal: true

# UserHelper
module UserHelper
  # ユーザー表示情報を返す（ハッシュを返す）
  # 引数は user オブジェクト（または nil）のみを受け付ける
  # - user が nil / 匿名フラグ / 論理削除 の場合は
  #   - pen_name: ANONYMOUS_DISPLAY
  #   - profile_icon_image: ''
  # - それ以外はユーザーの pen_name / profile_icon_image を返す
  # 返り値はハッシュ: { pen_name: ..., profile_icon_image: ... }
  def user_display_info(user)
    # 引数は user オブジェクトまたは nil を期待（コントローラで作者オブジェクトを渡す設計）
    return { pen_name: anonymous_display, profile_icon_image: '' } if masked_user?(user)

    pen = user.respond_to?(:pen_name) ? user.pen_name : nil
    profile = user.respond_to?(:profile_icon_image) ? user.profile_icon_image : ''

    {
      pen_name: pen.presence || anonymous_display,
      profile_icon_image: profile.presence || ''
    }
  end

  private

  # 匿名表示文字列を返す（initializer がロードされていない場合はデフォルト '匿名' を返す）
  def anonymous_display
    defined?(ANONYMOUS_DISPLAY) ? ANONYMOUS_DISPLAY : '匿名'
  end

  # マスクが必要なユーザーかどうかを判定する補助メソッド
  # - nil の場合は true
  # - is_anonymous?/is_anonymous が true の場合は true
  # - deleted_at が存在する（論理削除）場合は true
  def masked_user?(user)
    return true if user.nil?
    return true if user.try(:is_anonymous?)
    return true if user.try(:is_anonymous)
    return true if user.respond_to?(:deleted_at) && user.deleted_at.present?

    false
  end
end
