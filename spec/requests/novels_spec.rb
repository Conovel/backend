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
      # クッキーにJWTトークンを設定
      login_as(user)
    end

    it 'returns a successful response' do
      # コントローラのヘルパー実装を監視し、各 example ごとに呼び出し回数をカウント
      counter = CallCounter.new
      allow_any_instance_of(V1::NovelsController)
        .to receive(:user_display_info)
        .and_wrap_original do |original, *args, &block|
        counter.tick
        original.call(*args, &block)
      end

      get '/v1/novels'
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct number of novels' do
      # コントローラのヘルパー実装を監視し、各 example ごとに呼び出し回数をカウント
      counter = CallCounter.new
      allow_any_instance_of(V1::NovelsController)
        .to receive(:user_display_info)
        .and_wrap_original do |original, *args, &block|
        counter.tick
        original.call(*args, &block)
      end

      get '/v1/novels'
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(1)
    end

    it 'returns the correct novel data' do
      # コントローラのヘルパー実装を監視し、各 example ごとに呼び出し回数をカウント
      counter = CallCounter.new
      allow_any_instance_of(V1::NovelsController)
        .to receive(:user_display_info)
        .and_wrap_original do |original, *args, &block|
        counter.tick
        original.call(*args, &block)
      end

      get '/v1/novels'
      json_response = JSON.parse(response.body).first
      expect(json_response['titleId']).to eq(title.title_id)
      expect(json_response['title']).to eq(title.title)
      expect(json_response['authorUserId']).to eq(user.user_id)
      expect(json_response['authorPenName']).to eq(user.pen_name)
      expect(json_response['profileIconImage']).to eq(user.profile_icon_image)
      expect(json_response['isNew']).to be_truthy
      expect(json_response['isFamous']).to be_truthy
      expect(json_response['viewCount']).to eq(0)
      expect(json_response['evaluationGoodCount']).to eq(FAMOUS_EVALUATION_THRESHOLD)
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
      # クッキーにJWTトークンを設定
      login_as(user2)
    end

    # リクエストは各 example 内で実行し、ヘルパー呼び出しの期待値を設定可能にする

    it 'returns a successful response' do
      # コントローラのヘルパー実装を監視し、各 example ごとに呼び出し回数をカウント
      counter = CallCounter.new
      allow_any_instance_of(V1::NovelsController)
        .to receive(:user_display_info)
        .and_wrap_original do |original, *args, &block|
        counter.tick
        original.call(*args, &block)
      end

      get "/v1/novels/#{title.title_id}"
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct novel detail data' do
      # コントローラのヘルパー実装を監視し、各 example ごとに呼び出し回数をカウント
      counter = CallCounter.new
      allow_any_instance_of(V1::NovelsController)
        .to receive(:user_display_info)
        .and_wrap_original do |original, *args, &block|
        counter.tick
        original.call(*args, &block)
      end

      get "/v1/novels/#{title.title_id}"
      expect(counter.count).to eq(1)
      json_response = JSON.parse(response.body)
      expect(json_response['titleId']).to eq(title.title_id)
      expect(json_response['title']).to eq(title.title)
      expect(json_response['authorUserId']).to eq(user1.user_id)
      expect(json_response['authorPenName']).to eq(user1.pen_name)
      expect(json_response['profileIconImage']).to eq(user1.profile_icon_image)
      expect(json_response['isNew']).to be_truthy
      expect(json_response['isFamous']).to be_truthy
      expect(json_response['viewCount']).to eq(3) # 投稿閲覧数は3
      expect(json_response['evaluationGoodCount']).to eq(FAMOUS_EVALUATION_THRESHOLD)
      expect(json_response['mainCopy']).to eq(title.main_copy)
      expect(json_response['sentenceUserCount']).to eq(2) # 投稿者数は2
      expect(json_response['sentenceHierarchyCount']).to eq(3)
      expect(json_response['readerCount']).to eq(1) # 読者数は1
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

  # 投稿(sentences)が閲覧された時のテスト
  context 'when sentences are viewed' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }
    # ユーザー1が小説を作成
    let!(:title) { create(:title, author_user: user1) }
    # ユーザー1が投稿1、ユーザー2が投稿2を作成
    let!(:sentence1) { create(:sentence, user: user1, title:, sentence_hierarchy: 1) }
    let!(:sentence2) { create(:sentence, user: user2, title:, sentence_hierarchy: 2) }

    before do
      # ユーザー1でログイン
      allow_any_instance_of(ApplicationController).to receive(:current_user_id).and_return(user1.user_id)
    end

    before do
      # クッキーにJWTトークンを設定
      login_as(user2)
    end

    # 投稿が閲覧された時のview_countとreader_countの更新のテスト
    it 'creates a ViewedSentence record and updates reader_count' do
      # 投稿1を閲覧
      get("/v1/sentences/#{sentence1.sentence_id}")
      expect(response).to have_http_status(:ok)

      # ViewedSentenceレコードが作成されたか確認
      viewed_sentence = ViewedSentence.find_by(viewed_sentence_id: sentence1.sentence_id, viewed_user_id: user1.user_id)
      expect(viewed_sentence).not_to be_nil

      # novels_controllerでview_countとreader_countが更新されているか確認-1
      # コントローラのヘルパー実装を監視し、各 example ごとに呼び出し回数をカウント
      counter = CallCounter.new
      allow_any_instance_of(V1::NovelsController)
        .to receive(:user_display_info)
        .and_wrap_original do |original, *args, &block|
        counter.tick
        original.call(*args, &block)
      end

      # indexのテスト
      get("/v1/novels/#{title.title_id}")
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['viewCount']).to eq(1) # 投稿閲覧数は1
      # showのテスト
      get("/v1/novels/#{title.title_id}")
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['viewCount']).to eq(1) # 投稿閲覧数は1
      expect(json_response['readerCount']).to eq(1) # 読者数も1

      # 投稿1を再閲覧
      get("/v1/sentences/#{sentence1.sentence_id}")
      expect(response).to have_http_status(:ok)

      # novels_controllerでview_countとreader_countが更新されているか確認-2
      # indexのテスト
      get("/v1/novels/#{title.title_id}")
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['viewCount']).to eq(1) # 同じユーザーが閲覧したため、投稿閲覧数は1のまま
      # showのテスト
      get("/v1/novels/#{title.title_id}")
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['viewCount']).to eq(1) # 同じユーザーが閲覧したため、投稿閲覧数は1のまま
      expect(json_response['readerCount']).to eq(1) # 同じユーザーが閲覧したため、読者数は1のまま

      # 投稿2を閲覧
      get("/v1/sentences/#{sentence2.sentence_id}")
      expect(response).to have_http_status(:ok)

      # novels_controllerでview_countとreader_countが更新されているか確認-3
      # indexのテスト
      get("/v1/novels/#{title.title_id}")
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['viewCount']).to eq(2) # 異なる投稿を閲覧したため投稿閲覧数は2になる
      # showのテスト
      get("/v1/novels/#{title.title_id}")
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['viewCount']).to eq(2) # 異なる投稿を閲覧したため投稿閲覧数は2になる
      expect(json_response['readerCount']).to eq(1) # 同じユーザーが閲覧したため、読者数は1のまま

      # コントローラのヘルパー実装を監視し、各 example ごとに呼び出し回数をカウント
      counter = CallCounter.new
      allow_any_instance_of(V1::NovelsController)
        .to receive(:user_display_info)
        .and_wrap_original do |original, *args, &block|
        counter.tick
        original.call(*args, &block)
      end
    end

    # 別のユーザーが閲覧した時のview_countとreader_countの更新のテスト
    it 'updates reader_count when viewed by different users' do
      # ユーザー1が投稿1を閲覧
      get("/v1/sentences/#{sentence1.sentence_id}")
      expect(response).to have_http_status(:ok)

      # novels_controllerでview_countとreader_countが更新されているか確認-1
      # コントローラのヘルパー実装を監視し、各 example ごとに呼び出し回数をカウント
      counter = CallCounter.new
      allow_any_instance_of(V1::NovelsController)
        .to receive(:user_display_info)
        .and_wrap_original do |original, *args, &block|
        counter.tick
        original.call(*args, &block)
      end

      # indexのテスト
      get("/v1/novels/#{title.title_id}")
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['viewCount']).to eq(1) # 投稿閲覧数は1
      # showのテスト
      get("/v1/novels/#{title.title_id}")
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['viewCount']).to eq(1) # 投稿閲覧数は1
      expect(json_response['readerCount']).to eq(1) # 読者数も1

      # ユーザー2でログイン
      allow_any_instance_of(ApplicationController).to receive(:current_user_id).and_return(user2.user_id)

      # ユーザー2が投稿1を閲覧
      get("/v1/sentences/#{sentence1.sentence_id}")
      expect(response).to have_http_status(:ok)

      # novels_controllerでview_countとreader_countが更新されているか確認-2
      # indexのテスト
      get("/v1/novels/#{title.title_id}")
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['viewCount']).to eq(2) # 異なるユーザーが閲覧したため、投稿閲覧数は2になる
      # showのテスト
      get("/v1/novels/#{title.title_id}")
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['viewCount']).to eq(2) # 異なるユーザーが閲覧したため、投稿閲覧数は2になる
      expect(json_response['readerCount']).to eq(2) # 異なるユーザーが閲覧したため、読者数は2になる

      # ユーザー2が投稿2を閲覧
      get("/v1/sentences/#{sentence2.sentence_id}")
      expect(response).to have_http_status(:ok)

      # novels_controllerでview_countとreader_countが更新されているか確認-3
      # indexのテスト
      get("/v1/novels/#{title.title_id}")
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['viewCount']).to eq(3) # 異なる投稿を閲覧したため投稿閲覧数は3になる
      # showのテスト
      get("/v1/novels/#{title.title_id}")
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['viewCount']).to eq(3) # 異なる投稿を閲覧したため投稿閲覧数は3になる
      expect(json_response['readerCount']).to eq(2) # 同じユーザーが閲覧したため、読者数は2のまま

      # 呼び出しが行われたことを検証
      # 一連の index + show の組み合わせが3回実行されている
      # - 1回目の組: index -> show  (各1回ずつ呼ばれる) = 2回
      # - 2回目の組: index -> show  = 2回
      # - 3回目の組: index -> show  = 2回
      # 合計 = 2 + 2 + 2 = 6 回（したがって expect(counter.count).to eq(6)）
      expect(counter.count).to eq(6)
    end
  end
end
