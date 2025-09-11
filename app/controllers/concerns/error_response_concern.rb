# frozen_string_literal: true

# ErrorResponseConcern
# Controller-level concern that centralizes rendering of structured error responses
# and common parameter checks used across API controllers.
module ErrorResponseConcern
  extend ActiveSupport::Concern

  included do
    # nothing for now
  end

  def render_error_response(error_code, error_message, additional_data = {})
    error_response = {
      error: {
        code: error_code,
        message: error_message
      }
    }
    error_response[:data] = additional_data[:data] if additional_data[:data]
    render json: error_response, status: error_code
  end

  def check_required_keys(params, required_keys)
    missing_keys = required_keys.reject { |key| params.key?(key) }
    if missing_keys.any?
      render_error_response(422, "必須項目が不足しています: #{missing_keys.join(', ')}")
      Rails.logger.error("[ERROR] 必須項目が不足しています: #{missing_keys.join(', ')}")
      return false
    end
    true
  end
end
