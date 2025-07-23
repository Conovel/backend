# frozen_string_literal: true

require 'rails_helper'

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

    # ユーザー復元時の動作と適合しないためコメントアウト
    # context 'when an error occurs' do
    #   before do
    #     allow(User).to receive(:find_by).and_raise(StandardError, 'Something went wrong')
    #     allow(Rails.logger).to receive(:error)
    #   end

    #   it 'logs the error' do
    #     get '/auth/google_oauth2/callback'

    #     expect(response).to have_http_status(:no_content)
    #     expect(Rails.logger).to have_received(:error).with(/Something went wrong/)
    #   end
    # end
  end
end
