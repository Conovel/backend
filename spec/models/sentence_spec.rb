# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sentence, type: :model do
  let(:user) { User.find_by(email: 'user1@example.com') }
  let(:title) { Title.find_by(title: '吾輩は猫である') }

  it 'is valid with valid attributes' do
    sentence = Sentence.new(
      sentence_id: 1,
      sentence_user_id: user.id,
      sentence: '吾輩は猫である。',
      title_id: title.id,
      sentence_hierarchy: '1'
    )
    expect(sentence).to be_valid
  end

  it 'is not valid without a sentence' do
    sentence = Sentence.new(
      sentence_id: 1,
      sentence_user_id: user.id,
      title_id: title.id,
      sentence_hierarchy: '1'
    )
    expect(sentence).not_to be_valid
  end
end
