# frozen_string_literal: true

# ErrorResponseHelper
module ErrorResponseHelper
  # エラーレスポンスを返却
  def render_error_response(error_code, error_message)
    error_response = {
      error: {
        code: error_code,
        message: error_message
      }
    }
    render json: error_response, status: error_code
  end
end
