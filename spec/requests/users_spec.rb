# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::UsersController', type: :request do
  describe 'POST /v1/users/me/update' do
    let(:current_user_id) { 2 } # current_user_idを2に設定（仮）
    let!(:users) { create_list(:user, 4) } # 4人のユーザーを作成
    let(:user) { users.find { |u| u.user_id == current_user_id } } # current_user_idのユーザーを取得
    let(:headers) { auth_headers(user) } # ヘッダーにAuthenticationを追加
    let(:valid_params) do
      {
        user: {
          pen_name: 'NewPenName',
          nick_name: 'NewNickName'
        }
      }
    end
    let(:invalid_params) do
      {
        user: {
          pen_name: '', # 無効な値
          nick_name: 'NewNickName'
        }
      }
    end
    let(:miissing_params) do
      {
        user: {
          pen_name: 'NewPenName',
          nick_name: 'NewNickName',
          xxx: 'NewNickName' # 存在しないパラメータ
        }
      }
    end

    context 'without any evaluations' do
      it 'updates the user and returns a successful response with evaluation_good_count as 0' do
        post('/v1/users/me/update', params: valid_params, headers:)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['evaluation_good_count']).to eq(0)
      end
    end

    context 'with a good evaluation' do
      # current_user以外のユーザーを評価者に設定
      let(:evaluator) { users.find { |u| u.user_id != current_user_id } }
      let(:evaluator_headers) { auth_headers(evaluator) }

      before do
        # current_userが書いた文章を評価者が評価する
        sentence = create(:sentence, sentence_user_id: user.user_id)
        evaluation_valid_attributes = { sentence_id: sentence.sentence_id, evaluation: 'good' }
        post('/v1/evaluations', params: evaluation_valid_attributes, headers: evaluator_headers)
      end

      it 'updates the user and returns a successful response with evaluation_good_count as 1' do
        post('/v1/users/me/update', params: valid_params, headers:)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['evaluation_good_count']).to eq(1)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error response' do
        post('/v1/users/me/update', params: invalid_params, headers:)

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']['message']).to include('ユーザーアカウント情報の更新に失敗しました')
      end
    end

    context 'with miissing parameters' do
      it 'returns an error response' do
        post('/v1/users/me/update', params: miissing_params, headers:)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['evaluation_good_count']).to eq(0)
      end
    end
  end
end
