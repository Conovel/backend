# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Evaluations', type: :request do
  let!(:user) { create(:user) }
  let!(:sentence) { create(:sentence) }

  describe 'POST /v1/evaluations' do
    let(:valid_attributes) { { sentenceId: sentence.sentence_id, evaluation: 'good' } }

    before do
      # クッキーにJWTトークンを設定
      login_as(user)
      # 閲覧済みレコードを追加
      ViewedSentence.create!(
        viewed_sentence_id: sentence.sentence_id,
        viewed_user_id: user.user_id,
        viewed_at: Time.current
      )
    end

    context 'when the request is valid (good)' do
      it 'creates a new evaluation' do
        post('/v1/evaluations', params: valid_attributes)
        expect(response).to have_http_status(:created)
        expect(json['sentenceId'].to_i).to eq(sentence.sentence_id)
        expect(json['evaluationGoodCount']).to eq(1)
        expect(json['evaluationStayCount']).to eq(0)
      end
    end

    context 'when the request is valid (stay)' do
      it 'creates a new evaluation' do
        post('/v1/evaluations', params: valid_attributes.merge(evaluation: 'stay'))
        expect(response).to have_http_status(:created)
        expect(json['sentenceId'].to_i).to eq(sentence.sentence_id)
        expect(json['evaluationGoodCount']).to eq(0)
        expect(json['evaluationStayCount']).to eq(1)
      end
    end

    context 'when the request is valid (bad)' do
      it 'creates a new evaluation' do
        post('/v1/evaluations', params: valid_attributes.merge(evaluation: 'bad'))
        expect(response).to have_http_status(:created)
        expect(json['sentenceId'].to_i).to eq(sentence.sentence_id)
        expect(json['evaluationGoodCount']).to eq(0)
        expect(json['evaluationStayCount']).to eq(0)
      end
    end

    context 'when updating an existing evaluation (from good to stay)' do
      it 'updates the evaluation' do
        post('/v1/evaluations', params: valid_attributes)
        post('/v1/evaluations', params: valid_attributes.merge(evaluation: 'stay'))
        expect(response).to have_http_status(:created)
        expect(json['sentenceId'].to_i).to eq(sentence.sentence_id)
        expect(json['evaluationGoodCount']).to eq(0)
        expect(json['evaluationStayCount']).to eq(1)
      end
    end

    context 'when sentenceId is missing' do
      it 'returns a required parameter error' do
        post('/v1/evaluations', params: { evaluation: 'good' }) # sentenceIdなし
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to include('必須項目が不足しています')
        expect(json_response['error']['message']).to include('sentenceId')
      end
    end

    context 'when evaluation is missing' do
      it 'returns a required parameter error' do
        post('/v1/evaluations', params: { sentenceId: sentence.sentence_id }) # evaluationなし
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to include('必須項目が不足しています')
        expect(json_response['error']['message']).to include('evaluation')
      end
    end

    context 'when both sentenceId and evaluation are missing' do
      it 'returns a required parameter error for both' do
        post('/v1/evaluations', params: {}) # 両方なし
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to include('必須項目が不足しています')
        expect(json_response['error']['message']).to include('sentenceId')
        expect(json_response['error']['message']).to include('evaluation')
      end
    end

    context 'When sentenceId does not exist' do
      it 'returns a validation failure message' do
        post('/v1/evaluations', params: valid_attributes.merge(sentenceId: 1000))
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to include('指定された投稿が存在しません。')
      end
    end

    context 'When sentenceId is invalid' do
      it 'returns a validation failure message' do
        post('/v1/evaluations', params: valid_attributes.merge(sentenceId: 'aaa'))
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to include('指定された投稿が存在しません。')
      end
    end

    context 'When sentenceId is blank' do
      it 'returns a validation failure message' do
        post('/v1/evaluations', params: valid_attributes.merge(sentenceId: nil))
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to include('指定された投稿が存在しません。')
      end
    end

    context 'when the user has not viewed the sentence' do
      let(:other_user) { create(:user) }

      before do
        login_as(other_user)
      end

      it 'returns a forbidden error' do
        post('/v1/evaluations', params: { sentenceId: sentence.sentence_id, evaluation: 'good' })
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:forbidden)
        expect(json_response['error']['code']).to eq(403)
        expect(json_response['error']['message']).to include('この投稿を閲覧していないため評価できません。')
      end
    end

    context 'When evaluation is disabled' do
      it 'returns a validation failure message' do
        post('/v1/evaluations', params: valid_attributes.merge(evaluation: 'aaa'))
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to include('無効な値が含まれていました。')
      end
    end

    context 'When evaluation is blank' do
      it 'returns a validation failure message' do
        post('/v1/evaluations', params: valid_attributes.merge(evaluation: ''))
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to include('投稿の評価に失敗しました。')
      end
    end
  end
end
