# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::UsersController', type: :request do
  describe 'POST /v1/users/me/update' do
    let(:current_user_id) { 2 } # current_user_idを2に設定（仮）
    let!(:users) { create_list(:user, 4) } # 4人のユーザーを作成
    let(:user) { users.find { |u| u.user_id == current_user_id } } # current_user_idのユーザーを取得

    before do
      # クッキーにJWTトークンを設定
      login_as(user)
    end

    let(:valid_params) do
      {
        userName: 'コノベル新太郎',
        nickName: 'ジロさん',
        birthYm: '199001',
        agreedTermsVersion: 1,
        isAnonymous: false,
        profileIconImage: 'icon2.png'
      }
    end
    let(:invalid_params) do
      {
        userName: '', # 無効な値
        nickName: 'ジロさん',
        birthYm: '199001',
        agreedTermsVersion: 1,
        isAnonymous: false,
        profileIconImage: 'icon2.png'
      }
    end
    let(:miissing_params) do
      {
        userName: 'コノベル新太郎',
        nickName: 'ジロさん',
        birthYm: '199001',
        agreedTermsVersion: 1,
        isAnonymous: false,
        profileIconImage: 'icon2.png',
        xxx: 'NewNickName' # 存在しないパラメータ
      }
    end

    context 'without any evaluations' do
      it 'updates the user and returns a successful response with evaluation_good_count as 0' do
        post('/v1/users/me/update', params: valid_params)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['evaluationGoodCount']).to eq(0)
      end
    end

    context 'with a good evaluation' do
      # current_user以外のユーザーを評価者に設定
      let(:evaluator) { users.find { |u| u.user_id != current_user_id } }

      before do
        login_as(user) # 投稿者本人でログイン
        sentence = create(:sentence, sentence_user_id: user.user_id)
        # API経由ではなく、FactoryBotで直接評価レコードを作成
        create(:evaluation, sentence:, evaluator_user: evaluator, evaluation: :good)
      end

      it 'updates the user and returns a successful response with evaluation_good_count as 1' do
        login_as(user) # 元のユーザーに戻す
        post('/v1/users/me/update', params: valid_params)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['evaluationGoodCount']).to eq(1)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error response' do
        post('/v1/users/me/update', params: invalid_params)

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']['message']).to include('ユーザーアカウント情報の更新に失敗しました')
      end
    end

    context 'with miissing parameters' do
      it 'It updates the user, omitting any non-existent parameters, and returns a success response.' do
        post('/v1/users/me/update', params: miissing_params)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['evaluationGoodCount']).to eq(0)
      end
    end
  end
end
