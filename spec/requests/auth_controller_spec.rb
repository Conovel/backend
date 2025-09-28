# frozen_string_literal: true

require 'rails_helper'
require 'uri'
require 'cgi'

RSpec.describe 'V1::AuthController', type: :request do
  let(:frontend_url) { ENV.fetch('DEVELOPMENT_ORIGIN_URL', 'http://localhost:3000') }

  describe 'GET /auth/google_oauth2/callback' do
    context 'when user is new' do
      it 'creates a new user and redirects to /account' do
        expect do
          get '/auth/google_oauth2/callback'
        end.to change(User, :count).by(1)

        expect(response).to redirect_to("#{frontend_url}/account")
      end
    end

    context 'when user already exists' do
      let!(:existing_user) { create(:user, google_sub: '123456789') }

      it 'does not create a new user and redirects to /account' do
        expect do
          get '/auth/google_oauth2/callback'
        end.not_to change(User, :count)

        expect(response).to redirect_to("#{frontend_url}/account")
      end
    end

    context 'when an error occurs' do
      before do
        allow(User).to receive(:find_by).and_raise(StandardError, 'サーバーエラーが発生しました')
        allow(Rails.logger).to receive(:error)
      end

      it 'logs the error' do
        get '/auth/google_oauth2/callback'

        # path と query を分割して取り出す
        location = response.location
        path, = location.split('?', 2)

        # path：リダイレクトの確認
        expect(path).to include('/login')
        expect(response).to have_http_status(:found)

        # query：メッセージの確認
        params = parsed_location_params(response)
        expect(params['message']).to eq('サーバーエラーが発生しました')
        expect(params['messageLevel']).to eq('error')

        expect(Rails.logger).to have_received(:error).with(a_string_including('サーバーエラーが発生しました'))
      end
    end

    context 'when save fails' do
      before do
        # ユーザーが見つからない状態を作る（新規作成フローに入るため）
        allow(User).to receive(:find_by).and_return(nil)

        # save! が例外を投げるようにする（エラーメッセージを含める）
        user_with_errors = User.new
        user_with_errors.errors.add(:base, 'バリデーションエラー')
        allow_any_instance_of(User).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(user_with_errors))

        allow(Rails.logger).to receive(:error)
      end

      it 'logs the validation error and redirects to login' do
        get '/auth/google_oauth2/callback'

        # path と query を分割して取り出す
        location = response.location
        path, = location.split('?', 2)

        # path：リダイレクトの確認
        expect(path).to include('/login')
        expect(response).to have_http_status(:found)

        # query：メッセージの確認
        params = parsed_location_params(response)
        expect(params['message']).to eq('ユーザーの保存に失敗しました')
        expect(params['messageLevel']).to eq('error')

        expect(Rails.logger).to have_received(:error).with(a_string_including('バリデーションエラー'))
      end
    end

    context 'when creation fails after save (outer rescue)' do
      before do
        # 新規作成フローに入る
        allow(User).to receive(:find_by).and_return(nil)

        # save! は成功するようにする（内側の rescue を通さない）
        allow_any_instance_of(User).to receive(:save!).and_return(true)

        # その後の update! が RecordInvalid を投げる（set_refresh_token 内の update! を想定）
        user_with_errors = User.new
        user_with_errors.errors.add(:base, '外側のバリデーションエラー')
        allow_any_instance_of(User).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(user_with_errors))

        allow(Rails.logger).to receive(:error)
      end

      it 'logs the creation error and redirects to login' do
        get '/auth/google_oauth2/callback'

        # path と query を分割して取り出す
        location = response.location
        path, = location.split('?', 2)

        # path：リダイレクトの確認
        expect(path).to include('/login')
        expect(response).to have_http_status(:found)

        # query：メッセージの確認
        params = parsed_location_params(response)
        expect(params['message']).to eq('ユーザー作成に失敗しました')
        expect(params['messageLevel']).to eq('error')

        expect(Rails.logger).to have_received(:error).with(a_string_including('外側のバリデーションエラー'))
      end
    end
  end
end
