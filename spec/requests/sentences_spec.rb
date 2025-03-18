# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sentences', type: :request do
  # showのデータ
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
  let!(:parallel_sentence1) do
    create(:sentence, :with_specific_content, user: users[2], title:, content: 'かかかかか',
                                              parent_sentence:, hierarchy: 2)
  end
  let!(:parallel_sentence2) do
    create(:sentence, :with_specific_content, user: users[3], title:, content: 'ききききき',
                                              parent_sentence:, hierarchy: 2)
  end
  let!(:parallel_sentence2) do
    create(:sentence, :with_specific_content, user: users[3], title:, content: 'ききききき',
                                              parent_sentence:, hierarchy: 2)
  end
  let(:not_exist_sentence_id) { 1000 }

  # createのデータ
  let(:valid_attributes) do
    {
      parent_sentence_id: parent_sentence.sentence_id,
      sentence: '投稿追加テストです。',
      parent_updated_at: parent_sentence.updated_at
    }
  end

  # showのテスト
  describe 'GET /v1/sentences/:sentence_id' do
    let(:headers) { auth_headers } # ヘッダーにAuthorizationを追加

    context 'when the sentence exists' do
      it 'returns the sentence' do
        main_sentence

        get("/v1/sentences/#{main_sentence.sentence_id}", headers:)
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        # レスポンスを確認
        # puts json_response

        expect(json_response['main']['sentence']).to eq('いいいいい')
        expect(json_response).to have_key('parent')
        expect(json_response['parent']).not_to be_nil
        expect(json_response['parent']['sentence']).to eq('あああああ')
        expect(json_response).to have_key('children')
        expect(json_response['children'][0]).not_to be_nil
        expect(json_response['children'][0]['sentence']).to eq('ううううう')
        expect(json_response).to have_key('parallels')
        expect(json_response['parallels'][0]).not_to be_nil
        expect(json_response['parallels'][0]['sentence']).to eq('かかかかか')
      end

      it 'returns a 420 error when viewed_sentence save fails' do
        main_sentence
        viewed_sentence_double = instance_double('ViewedSentence', save!: nil, new_record?: true,
                                                                   viewed_at: Time.current)
        allow(viewed_sentence_double).to receive(:viewed_at=)
        allow(viewed_sentence_double).to receive(:created_at)
        allow(viewed_sentence_double).to receive(:updated_at)
        allow(ViewedSentence).to receive(:find_or_initialize_by).and_return(viewed_sentence_double)
        allow(viewed_sentence_double).to receive(:save!).and_raise(StandardError.new('DB error'))

        get("/v1/sentences/#{main_sentence.sentence_id}", headers:)
        expect(response).to have_http_status(420)
        json_response = JSON.parse(response.body)
        expect(json_response['error']['message']).to eq('投稿の取得に失敗しました。')
      end
    end

    context 'when the sentence does not exist' do
      it 'returns a 404 not found error' do
        get("/v1/sentences/#{not_exist_sentence_id}", headers:)
        expect(response).to have_http_status(404)
        json_response = JSON.parse(response.body)
        expect(json_response['error']['message']).to eq('投稿が見つかりません。')
      end
    end
  end

  # createのテスト
  describe 'POST /v1/sentences' do
    let(:headers) { auth_headers } # ヘッダーにAuthorizationを追加

    context 'with valid parameters' do
      it 'creates a new Sentence' do
        expect do
          post v1_sentences_path, params: valid_attributes, headers:
        end.to change(Sentence, :count).by(1)
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['main']['sentence']).to eq('投稿追加テストです。')
      end
    end

    context 'when required parameters are missing' do
      it 'returns an unprocessable entity status' do
        post(v1_sentences_path, params: valid_attributes.merge(sentence: ''), headers:)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to eq('投稿の追加に失敗しました。: sentence')
      end
    end

    context 'when parent_sentence_id does not exist' do
      it 'returns an unprocessable entity status' do
        post(v1_sentences_path, params: valid_attributes.merge(parent_sentence_id: 100), headers:)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to eq('親投稿が見つかりません。')
      end
    end

    context 'with invalid parameters' do
      it 'returns a conflict status' do
        post(v1_sentences_path, params: valid_attributes.merge(parent_updated_at: '2024-01-01T01:01:09.292+09:00'),
                                headers:)
        expect(response).to have_http_status(:conflict)
        json_response = JSON.parse(response.body)
        expect(json_response['error']['code']).to eq(409)
        expect(json_response['error']['message']).to eq('投稿編集の途中で親投稿が編集されたため、投稿を保留しています。')
      end
    end

    context 'when consecutive self post is detected' do
      it 'returns an unprocessable entity status' do
        post_user_id = 2 # Google認証未実装のため、仮のユーザーID
        post(v1_sentences_path, params: valid_attributes.merge(parent_sentence_id: post_user_id), headers:)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to eq('自分自身の投稿の後に連続で投稿を追加することはできません。')
      end
    end

    context 'when sentence length exceeds the limit' do
      it 'returns an unprocessable entity status' do
        long_sentence = 'a' * 101
        post(v1_sentences_path, params: valid_attributes.merge(sentence: long_sentence), headers:)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to eq('投稿文字数の上限を超えています。修正後に再投稿をお願いします。')
      end
    end
  end
end
