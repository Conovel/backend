# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Sentence, type: :model do
  let!(:users) { create_list(:user, 4) }
  let!(:title) { create(:title, author_user: users[0]) }
  let!(:parent) do
    create(:sentence, :with_specific_content, user: users[0], title:, content: 'あああああ',
                                              parent: nil, hierarchy: 1)
  end
  let!(:main_sentence) do
    create(:sentence, :with_specific_content, user: users[1], title:, content: 'いいいいい',
                                              parent:, hierarchy: 2)
  end
  let!(:children_sentence1) do
    create(:sentence, :with_specific_content, user: users[2], title:, content: 'ううううう',
                                              parent: main_sentence, hierarchy: 3)
  end
  let!(:children_sentence2) do
    create(:sentence, :with_specific_content, user: users[3], title:, content: 'えええええ',
                                              parent: main_sentence, hierarchy: 3)
  end
  let!(:children_sentence3) do
    create(:sentence, :with_specific_content, user: users[0], title:, content: 'おおおおお',
                                              parent: main_sentence, hierarchy: 3)
  end

  it 'is valid with valid attributes' do
    sentence = build(:sentence, user: users.first, title:)
    expect(sentence).to be_valid
  end

  it 'is not valid without a sentence' do
    sentence = build(:sentence, user: users.first, title:, sentence: nil)
    expect(sentence).not_to be_valid
  end

  it 'has child sentences' do
    expect(main_sentence.children.count).to eq(3)
  end

  it 'belongs to a parent sentence' do
    expect(children_sentence1.parent).to eq(main_sentence)
  end
end
# rubocop:enable Metrics/BlockLength
