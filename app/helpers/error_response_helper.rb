# frozen_string_literal: true

# ErrorResponseHelper
module ErrorResponseHelper
  # エラーレスポンスを返却
  def render_error_response(error_code, error_message, additional_data = {})
    error_response = {
      error: {
        code: error_code,
        message: error_message
      }
    }.merge(additional_data)

    render json: error_response, status: error_code
  end
end
