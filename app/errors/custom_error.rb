# frozen_string_literal: true

# app/errors/custom_error.rb
class CustomError < StandardError
  attr_reader :code, :data

  def initialize(message, code, data = nil)
    super(message)
    @code = code
    @data = data
  end
end
