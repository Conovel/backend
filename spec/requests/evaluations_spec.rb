# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Evaluations', type: :request do
  let!(:user) { create(:user) }
  let!(:sentence) { create(:sentence) }

  describe 'POST /v1/evaluations' do
    let(:valid_attributes) { { sentence_id: sentence.sentence_id, evaluation: 'good' } }

    before do
      # クッキーにJWTトークンを設定
      login_as(user)
    end

    context 'when the request is valid (good)' do
      it 'creates a new evaluation' do
        post('/v1/evaluations', params: valid_attributes)
        expect(response).to have_http_status(:created)
        expect(json['sentence_id'].to_i).to eq(sentence.sentence_id)
        expect(json['evaluation_good_count']).to eq(1)
        expect(json['evaluation_stay_count']).to eq(0)
      end
    end

    context 'when the request is valid (stay)' do
      it 'creates a new evaluation' do
        post('/v1/evaluations', params: valid_attributes.merge(evaluation: 'stay'))
        expect(response).to have_http_status(:created)
        expect(json['sentence_id'].to_i).to eq(sentence.sentence_id)
        expect(json['evaluation_good_count']).to eq(0)
        expect(json['evaluation_stay_count']).to eq(1)
      end
    end

    context 'when the request is valid (bad)' do
      it 'creates a new evaluation' do
        post('/v1/evaluations', params: valid_attributes.merge(evaluation: 'bad'))
        expect(response).to have_http_status(:created)
        expect(json['sentence_id'].to_i).to eq(sentence.sentence_id)
        expect(json['evaluation_good_count']).to eq(0)
        expect(json['evaluation_stay_count']).to eq(0)
      end
    end

    context 'when updating an existing evaluation (from good to stay)' do
      it 'updates the evaluation' do
        post('/v1/evaluations', params: valid_attributes)
        post('/v1/evaluations', params: valid_attributes.merge(evaluation: 'stay'))
        expect(response).to have_http_status(:created)
        expect(json['sentence_id'].to_i).to eq(sentence.sentence_id)
        expect(json['evaluation_good_count']).to eq(0)
        expect(json['evaluation_stay_count']).to eq(1)
      end
    end

    context 'When sentence_id does not exist' do
      it 'returns a validation failure message' do
        post('/v1/evaluations', params: valid_attributes.merge(sentence_id: 1000))
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to include('投稿の評価に失敗しました。')
      end
    end

    context 'When sentence_id is invalid' do
      it 'returns a validation failure message' do
        post('/v1/evaluations', params: valid_attributes.merge(sentence_id: 'aaa'))
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to include('投稿の評価に失敗しました。')
      end
    end

    context 'When sentence_id is blank' do
      it 'returns a validation failure message' do
        post('/v1/evaluations', params: valid_attributes.merge(sentence_id: nil))
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['message']).to include('投稿の評価に失敗しました。')
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
