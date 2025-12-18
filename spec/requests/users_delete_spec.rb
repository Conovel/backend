# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::UsersDeleteController', type: :request do
  let(:current_user_id) { 2 } # current_user_idを2に設定（仮）
  let!(:users) { create_list(:user, 4) } # 4人のユーザーを作成
  let(:user) { users.find { |u| u.user_id == current_user_id } } # current_user_idのユーザーを取得

  describe 'POST /v1/users/me/delete' do
    before do
      # クッキーにJWTトークンを設定
      login_as(user)
    end

    context 'when the user exists and deletion is successful' do
      it 'redirects to the top page and resets the session' do
        # ユーザーが存在する状態で削除を実行
        post('/v1/users/me/delete')

        expect(response).to have_http_status(:ok) # 200 OK
        expect(response.body).to be_empty # レスポンスボディが空であることを確認

        # セッションがリセットされていることを確認
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when the user does not exist' do
      it 'returns a 422 error with a message' do
        # ユーザーを削除してから再度削除を実行
        user.destroy
        post('/v1/users/me/delete', headers:)

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['error']['message']).to eq('ユーザーが見つかりません。')
      end
    end

    context 'when the deletion fails' do
      it 'returns a 422 error with a failure message' do
        # ユーザー削除時に例外を発生させる
        allow_any_instance_of(User).to receive(:destroy).and_return(false)

        post('/v1/users/me/delete', headers:)

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']['message']).to include('ユーザーアカウント情報の削除に失敗しました。')
      end
    end
  end
end
