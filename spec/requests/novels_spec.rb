# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Novels', type: :request do
  # indexのテスト
  describe 'GET /v1/novels' do
    let!(:user) { create(:user) }
    let!(:title) { create(:title, author_user: user) }
    let!(:sentence) { create(:sentence, user:, title:) }
    let!(:evaluations) do
      FAMOUS_EVALUATION_THRESHOLD.times do
        create(:evaluation, sentence:, evaluator_user: create(:user))
      end
    end

    before do
      get '/v1/novels'
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct number of novels' do
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(1)
    end

    it 'returns the correct novel data' do
      json_response = JSON.parse(response.body).first
      expect(json_response['title_id']).to eq(title.id)
      expect(json_response['title']).to eq(title.title)
      expect(json_response['author_user_id']).to eq(user.id)
      expect(json_response['author_user_name']).to eq(user.pen_name)
      expect(json_response['profile_icon_image']).to eq(user.profile_icon_image)
      expect(json_response['is_new']).to be_truthy
      expect(json_response['is_famous']).to be_truthy
      expect(json_response['view_count']).to eq(0)
      expect(json_response['evaluation_good_count']).to eq(FAMOUS_EVALUATION_THRESHOLD)
    end

    context 'when there are no novels' do
      before do
        allow(Title).to receive(:all).and_raise(ActiveRecord::RecordInvalid.new(Title.new))
        get '/v1/novels'
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the correct error message' do
        json_response = JSON.parse(response.body)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to eq('小説リストの取得に失敗しました。')
      end
    end
  end

  # showのテスト
  describe 'GET /v1/novels/:title_id' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }
    # ユーザー1が小説を作成
    let!(:title) { create(:title, author_user: user1) }
    # ユーザー1が投稿1と投稿3を作成、ユーザー2が投稿2を作成
    let!(:sentence1) { create(:sentence, user: user1, title:, sentence_hierarchy: 1) }
    let!(:sentence2) { create(:sentence, user: user2, title:, sentence_hierarchy: 2) }
    let!(:sentence3) { create(:sentence, user: user1, title:, sentence_hierarchy: 3) }
    # ユーザー3が投稿1, 2, 3を閲覧
    let!(:viewed_sentence1) { create(:viewed_sentence, sentence: sentence1, user: user3, viewed_at: Time.current) }
    let!(:viewed_sentence2) { create(:viewed_sentence, sentence: sentence2, user: user3, viewed_at: Time.current) }
    let!(:viewed_sentence3) { create(:viewed_sentence, sentence: sentence3, user: user3, viewed_at: Time.current) }
    # ユーザー1〜ユーザー5が投稿1を評価
    let!(:evaluations) do
      FAMOUS_EVALUATION_THRESHOLD.times do
        create(:evaluation, sentence: sentence1, evaluator_user: create(:user))
      end
    end

    before do
      get "/v1/novels/#{title.id}"
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct novel detail data' do
      json_response = JSON.parse(response.body)
      expect(json_response['title_id']).to eq(title.id)
      expect(json_response['title']).to eq(title.title)
      expect(json_response['author_user_id']).to eq(user1.user_id)
      expect(json_response['author_user_name']).to eq(user1.pen_name)
      expect(json_response['profile_icon_image']).to eq(user1.profile_icon_image)
      expect(json_response['is_new']).to be_truthy
      expect(json_response['is_famous']).to be_truthy
      expect(json_response['view_count']).to eq(3) # 投稿閲覧数は3
      expect(json_response['evaluation_good_count']).to eq(FAMOUS_EVALUATION_THRESHOLD)
      expect(json_response['main_copy']).to eq(title.main_copy)
      expect(json_response['sentence_user_count']).to eq(3) # 要確認:今は投稿閲覧数になっている（投稿者数だと2）
      expect(json_response['sentence_hierarchy_count']).to eq(3)
      expect(json_response['reader_count']).to eq(1) # 読者数は1
      expect(json_response['overview']).to eq(title.overview)
    end

    context 'when the novel does not exist' do
      before do
        get '/v1/novels/0'
      end

      it 'returns a 422 unprocessable entity error' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the correct error message' do
        json_response = JSON.parse(response.body)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to eq('小説の概要の取得に失敗しました。')
      end
    end
  end
end
