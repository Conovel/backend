# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sentences', type: :request do
  let!(:users) { create_list(:user, 4) }
  let!(:title) { create(:title, author_user: users[0]) }
  let!(:parent_sentence) do
    create(:sentence, :with_specific_content, user: users[0], title:, content: 'あああああ',
                                              parent_sentence: nil, hierarchy: 1)
  end
  let!(:main_sentence) do
    create(:sentence, :with_specific_content, user: users[1], title:, content: 'いいいいい',
                                              parent_sentence:, hierarchy: 2)
  end
  let!(:children_sentence1) do
    create(:sentence, :with_specific_content, user: users[2], title:, content: 'ううううう',
                                              parent_sentence: main_sentence, hierarchy: 3)
  end
  let!(:children_sentence2) do
    create(:sentence, :with_specific_content, user: users[3], title:, content: 'えええええ',
                                              parent_sentence: main_sentence, hierarchy: 3)
  end
  let!(:children_sentence3) do
    create(:sentence, :with_specific_content, user: users[0], title:, content: 'おおおおお',
                                              parent_sentence: main_sentence, hierarchy: 3)
  end

  describe 'GET /v1/sentences/:sentence_id' do
    it 'returns the sentence' do
      main_sentence

      get "/v1/sentences/#{main_sentence.sentence_id}"
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      # レスポンスを確認
      # puts json_response

      expect(json_response['main']['sentence']).to eq('いいいいい')
      expect(json_response).to have_key('parent')
      expect(json_response['parent']).not_to be_nil
      expect(json_response['parent']['sentence']).to eq('あああああ')
      expect(json_response).to have_key('parent_parallel')
      expect(json_response).to have_key('children')
      expect(json_response['children'][0]).not_to be_nil
      expect(json_response['children'][0]['sentence']).to eq('ううううう')
    end
  end
end
