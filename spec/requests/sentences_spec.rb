# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sentences', type: :request do
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

  describe 'GET /v1/sentences/:sentence_id' do
    it 'returns the sentence' do
      sentence = sentences.first

      get "/v1/sentences/#{sentence.sentence_id}"
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      # レスポンスを確認
      # puts json_response

      expect(json_response['main']['sentence']).to eq('吾輩は猫である。')
      if sentence.parent_sentence_id
        expect(json_response).to have_key('parent')
        expect(json_response['parent']).not_to be_nil
        expect(json_response['parent']['sentence']).to eq('名前はまだない。')
      end
      expect(json_response).to have_key('parent_parallel')
      expect(json_response).to have_key('children')
    end
  end
end
