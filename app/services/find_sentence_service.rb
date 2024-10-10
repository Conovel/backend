# frozen_string_literal: true

# Find Sentence Service
class FindSentenceService
  def initialize(sentence_id)
    @sentence_id = sentence_id
  end

  def call
    sentence = Sentence.find_by_id(@sentence_id)
    if sentence
      { success: true, sentence: }
    else
      { success: false, error: 'Sentence not found' }
    end
  end
end
