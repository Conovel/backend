# frozen_string_literal: true

# UserHelper
module UserHelper
  # 表示用の匿名文字列を定義（複数箇所で使うため定数化）
  ANONYMOUS_DISPLAY = '匿名'

  # ユーザーの表示名を返す
  # - 対象が nil / 匿名フラグ / 論理削除 の場合は ANONYMOUS_DISPLAY を返す
  # - それ以外では pen_name を返し、無ければ ANONYMOUS_DISPLAY にフォールバックする
  def display_pen_name(user)
    return ANONYMOUS_DISPLAY if masked_user?(user)

    pen = user.respond_to?(:pen_name) ? user.pen_name : nil
    pen.presence || ANONYMOUS_DISPLAY
  end

  private

  # マスクが必要なユーザーかどうかを判定する補助メソッド
  # - nil の場合は true
  # - is_anonymous?/is_anonymous が true の場合は true
  # - deleted_at が存在する（論理削除）場合は true
  def masked_user?(user)
    return true if user.nil?

    is_anon = if user.respond_to?(:is_anonymous?)
                user.is_anonymous?
              elsif user.respond_to?(:is_anonymous)
                user.is_anonymous
              else
                false
              end

    return true if is_anon
    return true if user.respond_to?(:deleted_at) && user.deleted_at.present?

    false
  end
end
