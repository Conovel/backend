# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Sentence, type: :model do
  let!(:users) { create_list(:user, 4) }
  let!(:title) { create(:title, author_user: users.first) }
  let!(:parent_sentence1) { create(:sentence, user: users.first, title:) }
  let!(:parent_sentence2) { create(:sentence, user: users.first, title:) }
  let!(:sentences) do
    [
      create(:sentence, :with_specific_content, user: users[0], title:, content: '吾輩は猫である。',
                                                parent_sentence_id: nil, hierarchy: 1),
      create(:sentence, :with_specific_content, user: users[1], title:, content: '名前はまだない。',
                                                parent_sentence_id: parent_sentence1.sentence_id, hierarchy: 2),
      create(:sentence, :with_specific_content, user: users[0], title:, content: 'どこで生れたかとんと見当がつかぬ。',
                                                parent_sentence_id: parent_sentence1.sentence_id, hierarchy: 3),
      create(:sentence, :with_specific_content, user: users[2], title:, content: '名前はもうある。',
                                                parent_sentence_id: parent_sentence1.sentence_id, hierarchy: 2),
      create(:sentence, :with_specific_content, user: users[1], title:, content: '名はミケと申す。',
                                                parent_sentence_id: parent_sentence2.sentence_id, hierarchy: 3),
      create(:sentence, :with_specific_content, user: users[1], title:, content: 'というのは嘘で、吾輩は犬である。',
                                                parent_sentence_id: parent_sentence1.sentence_id, hierarchy: 2),
      create(:sentence, :with_specific_content, user: users[1], title:, content: '名前はポチと申す。',
                                                parent_sentence_id: parent_sentence2.sentence_id, hierarchy: 3),
      create(:sentence, :with_specific_content, user: users[3], title:, content: 'というのは嘘で、吾輩は猿である。',
                                                parent_sentence_id: parent_sentence1.sentence_id, hierarchy: 2),
      create(:sentence, :with_specific_content, user: users[2], title:, content: '鬼ヶ島に行く途中である。',
                                                parent_sentence_id: parent_sentence2.sentence_id, hierarchy: 3),
      create(:sentence, :with_specific_content, user: users[0], title:, content: '名はジロウと申す。',
                                                parent_sentence_id: parent_sentence2.sentence_id, hierarchy: 3)
    ]
  end

  it 'is valid with valid attributes' do
    sentence = build(:sentence, user: users.first, title:)
    expect(sentence).to be_valid
  end

  it 'is not valid without a sentence' do
    sentence = build(:sentence, user: users.first, title:, sentence: nil)
    expect(sentence).not_to be_valid
  end
end
# rubocop:enable Metrics/BlockLength
