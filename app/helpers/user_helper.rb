# frozen_string_literal: true

# UserHelper
module UserHelper
  # Delegate to service for testability and single responsibility
  def user_display_info(user)
    UserDisplayInfoService.build(user)
  end
end
