# frozen_string_literal: true

require 'rails_helper'

# RSpec.describe 'V1::UsersController', type: :request do
#   let(:current_user_id) { 2 } # current_user_idを2に設定（仮）
#   let!(:users) { create_list(:user, 4) } # 4人のユーザーを作成
#   let(:user) { users.find { |u| u.user_id == current_user_id } } # current_user_idのユーザーを取得
#   let(:headers) { auth_headers(user) } # ヘッダーにAuthenticationを追加

#   describe 'POST /v1/users/me/delete' do
#     context 'when the user exists and deletion is successful' do
#       it 'redirects to the top page and resets the session' do
#         # ユーザーが存在する状態で削除を実行
#         post('/v1/users/me/delete', headers:)

#         expect(response).to have_http_status(:ok) # 200 OK
#         expect(response.body).to be_empty # レスポンスボディが空であることを確認

#         # リダイレクトを確認
#         # expect(response).to have_http_status(:found) # 302 Found
#         # expect(response.headers['Location']).to eq('http://localhost:3000') # トップ画面のURL

#         # セッションがリセットされていることを確認
#         expect(session[:user_id]).to be_nil
#       end
#     end

#     context 'when the user does not exist' do
#       it 'returns a 422 error with a message' do
#         # ユーザーを削除してから再度削除を実行
#         user.destroy
#         post('/v1/users/me/delete', headers:)

#         expect(response).to have_http_status(:unprocessable_entity)
#         json = JSON.parse(response.body)
#         expect(json['error']['message']).to eq('ユーザーが見つかりません。')
#       end
#     end

#     context 'when the deletion fails' do
#       it 'returns a 422 error with a failure message' do
#         # ユーザー削除時に例外を発生させる
#         allow_any_instance_of(User).to receive(:destroy).and_return(false)

#         post('/v1/users/me/delete', headers:)

#         expect(response).to have_http_status(:unprocessable_entity)
#         json = JSON.parse(response.body)
#         expect(json['error']['message']).to include('ユーザーアカウント情報の削除に失敗しました。')
#       end
#     end
#   end

#   describe 'POST /v1/users/me/update' do
#     let(:current_user_id) { 2 } # current_user_idを2に設定（仮）
#     let!(:users) { create_list(:user, 4) } # 4人のユーザーを作成
#     let(:user) { users.find { |u| u.user_id == current_user_id } } # current_user_idのユーザーを取得

#     before do
#       # クッキーにJWTトークンを設定
#       login_as(user)
#     end

#     let(:valid_params) do
#       {
#         penName: 'コノベル新太郎',
#         nickName: 'ジロさん',
#         birthYm: '199001',
#         agreedTermsVersion: 1,
#         isAnonymous: false,
#         profileIconImage: '' # null許容
#       }
#     end
#     let(:invalid_params) do
#       {
#         penName: '', # 無効な値
#         nickName: 'ジロさん',
#         birthYm: '199001',
#         agreedTermsVersion: 1,
#         isAnonymous: false,
#         profileIconImage: '' # null許容
#       }
#     end
#     let(:miissing_params) do
#       {
#         penName: 'コノベル新太郎',
#         nickName: 'ジロさん',
#         birthYm: '199001',
#         agreedTermsVersion: 1,
#         isAnonymous: false,
#         profileIconImage: '', # null許容
#         xxx: 'NewNickName' # 存在しないパラメータ
#       }
#     end

#     context 'without any evaluations' do
#       it 'updates the user and returns a successful response with evaluation_good_count as 0' do
#         post('/v1/users/me/update', params: valid_params)

#         expect(response).to have_http_status(:ok)
#         json = JSON.parse(response.body)
#         expect(json['evaluationGoodCount']).to eq(0)
#       end
#     end

#     context 'with a good evaluation' do
#       # current_user以外のユーザーを評価者に設定
#       let(:evaluator) { users.find { |u| u.user_id != current_user_id } }

#       before do
#         login_as(user) # 投稿者本人でログイン
#         sentence = create(:sentence, sentence_user_id: user.user_id)
#         # API経由ではなく、FactoryBotで直接評価レコードを作成
#         create(:evaluation, sentence:, evaluator_user: evaluator, evaluation: :good)
#       end

#       it 'updates the user and returns a successful response with evaluation_good_count as 1' do
#         login_as(user) # 元のユーザーに戻す
#         post('/v1/users/me/update', params: valid_params)

#         expect(response).to have_http_status(:ok)
#         json = JSON.parse(response.body)
#         expect(json['evaluationGoodCount']).to eq(1)
#       end
#     end

#     context 'with invalid parameters' do
#       it 'returns an error response' do
#         post('/v1/users/me/update', params: invalid_params)

#         expect(response).to have_http_status(:unprocessable_entity)
#         json = JSON.parse(response.body)
#         expect(json['error']['message']).to include('ユーザーアカウント情報の更新に失敗しました')
#       end
#     end

#     context 'with miissing parameters' do
#       it 'It updates the user, omitting any non-existent parameters, and returns a success response.' do
#         post('/v1/users/me/update', params: miissing_params)

#         expect(response).to have_http_status(:ok)
#         json = JSON.parse(response.body)
#         expect(json['evaluationGoodCount']).to eq(0)
#       end
#     end
#   end
# end
