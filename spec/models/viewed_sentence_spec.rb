# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ViewedSentence, type: :model do
  it 'is valid with valid attributes' do
    user = FactoryBot.create(:user)
    title = FactoryBot.create(:title, author_user: user)
    sentence = Sentence.create!(sentence_user_id: user.id, sentence: 'Sample sentence', title_id: title.id,
                                sentence_hierarchy: 1)
    viewed_sentence = ViewedSentence.new(viewed_sentence_id: sentence.id, viewed_user_id: user.id, viewed_at: Time.now)
    expect(viewed_sentence).to be_valid
  end

  it 'is not valid without a viewed_sentence_id' do
    viewed_sentence = ViewedSentence.new(viewed_sentence_id: nil, viewed_user_id: 1, viewed_at: Time.now)
    expect(viewed_sentence).not_to be_valid
  end

  it 'is not valid without a viewed_user_id' do
    viewed_sentence = ViewedSentence.new(viewed_sentence_id: 1, viewed_user_id: nil, viewed_at: Time.now)
    expect(viewed_sentence).not_to be_valid
  end

  it 'is not valid without a viewed_at' do
    viewed_sentence = ViewedSentence.new(viewed_sentence_id: 1, viewed_user_id: 1, viewed_at: nil)
    expect(viewed_sentence).not_to be_valid
  end
end
