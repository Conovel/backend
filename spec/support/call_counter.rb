# frozen_string_literal: true

class CallCounter
  attr_reader :count

  def initialize
    @count = 0
  end

  def tick
    @count += 1
  end
end
