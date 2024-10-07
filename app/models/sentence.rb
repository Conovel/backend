# frozen_string_literal: true

# Sentence model handles the sentences in the application.
# It validates the presence of the sentence attribute.
class Sentence < ApplicationRecord
  validates :sentence, presence: true

  def self.find_by_id(sentence_id)
    find(sentence_id)
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
