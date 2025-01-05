# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Novels', type: :request do
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
      get v1_novels_path
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
        get v1_novels_path
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
end
