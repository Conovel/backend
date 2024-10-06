# frozen_string_literal: true

# Sentence model handles the sentences in the application.
# It validates the presence of the sentence attribute.
class Sentence < ApplicationRecord
  validates :sentence, presence: true
end
