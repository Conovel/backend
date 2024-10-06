# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sentence, type: :model do
  it 'is valid with valid attributes' do
    sentence = Sentence.new(sentence_id: 1, sentence: 'This is a test sentence.')
    expect(sentence).to be_valid
  end

  it 'is not valid without a sentence' do
    sentence = Sentence.new(sentence_id: 1)
    expect(sentence).not_to be_valid
  end
end
