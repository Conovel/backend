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
      expect(json_response['sentence_user_count']).to eq(2) # 投稿者数は2
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

  # 投稿(sentences)が閲覧された時のshowのテスト
  context 'when sentences are viewed' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }
    # ユーザー1が小説を作成
    let!(:title) { create(:title, author_user: user1) }
    # ユーザー1が投稿1と投稿3を作成、ユーザー2が投稿2を作成
    let!(:sentence1) { create(:sentence, user: user1, title:, sentence_hierarchy: 1) }

    before do
      # ユーザー1でログイン
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
    end

    # 投稿が閲覧された時のreader_countの更新のテスト
    it 'creates a ViewedSentence record and updates reader_count' do
      # 投稿の閲覧をシミュレート
      get "/v1/sentences/#{sentence1.sentence_id}"
      expect(response).to have_http_status(:ok)

      # ViewedSentenceレコードが作成されたかどうかを確認
      viewed_sentence = ViewedSentence.find_by(viewed_sentence_id: sentence1.sentence_id, viewed_user_id: user1.id)
      expect(viewed_sentence).not_to be_nil

      # novels_controller で reader_count が更新されているかどうかを確認
      get "/v1/novels/#{title.title_id}"
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['view_count']).to eq(1) # 投稿閲覧数は1
      expect(json_response['reader_count']).to eq(1) # 読者数も1

      # 投稿の再閲覧をシミュレート
      get "/v1/sentences/#{sentence1.sentence_id}"
      expect(response).to have_http_status(:ok)

      # novels_controller で reader_count が再度更新されているかどうかを確認
      get "/v1/novels/#{title.title_id}"
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['view_count']).to eq(1) # 同じユーザーが閲覧したため、投稿閲覧数は1のまま
      expect(json_response['reader_count']).to eq(1) # 同じユーザーが閲覧したため、読者数は1のまま
    end

    # 別のユーザーが閲覧した時のreader_countの更新のテスト
    it 'updates reader_count when viewed by different users' do
      # ユーザー1でログインして閲覧
      get "/v1/sentences/#{sentence1.sentence_id}"
      expect(response).to have_http_status(:ok)

      # novels_controller で reader_count が更新されているかどうかを確認
      get "/v1/novels/#{title.title_id}"
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['view_count']).to eq(1) # 投稿閲覧数は1
      expect(json_response['reader_count']).to eq(1) # 読者数も1

      # ユーザー2でログイン
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user2)

      # ユーザー2で閲覧
      get "/v1/sentences/#{sentence1.sentence_id}"
      expect(response).to have_http_status(:ok)

      # novels_controller で reader_count が再度更新されているかどうかを確認
      get "/v1/novels/#{title.title_id}"
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['view_count']).to eq(2) # 異なるユーザーが閲覧したため、投稿閲覧数は2になる
      expect(json_response['reader_count']).to eq(2) # 異なるユーザーが閲覧したため、読者数は2になる
    end
  end
end
