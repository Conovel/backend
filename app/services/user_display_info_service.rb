# frozen_string_literal: true

# UserDisplayInfoService
# Service to produce a JSON-friendly display hash for a user-like object.
class UserDisplayInfoService
  ANONYMOUS_DEFAULT = '匿名'

  # Build a hash suitable for JSON responses from a user-like object (or nil)
  # Returns: { pen_name: String, profile_icon_image: String }
  def self.build(user)
    return { pen_name: anonymous_display, profile_icon_image: '' } if masked_user?(user)

    pen = user.respond_to?(:pen_name) ? user.pen_name : nil
    profile = user.respond_to?(:profile_icon_image) ? user.profile_icon_image : ''

    {
      pen_name: pen.present? ? pen : anonymous_display,
      profile_icon_image: profile.present? ? profile : ''
    }
  end

  def self.anonymous_display
    defined?(ANONYMOUS_DISPLAY) ? ANONYMOUS_DISPLAY : ANONYMOUS_DEFAULT
  end

  def self.masked_user?(user)
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
