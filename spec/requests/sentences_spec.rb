# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sentences', type: :request do
  let(:user) { User.find_by(email: 'user1@example.com') }
  let(:title) { Title.find_by(title: '吾輩は猫である。') }

  describe 'GET /v1/sentences/:id' do
    it 'returns the sentence' do
      # シードデータを使用
      sentence = Sentence.find_by(sentence: '吾輩は猫である。')

      get "/v1/sentences/#{sentence.sentence_id}"
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      # JSONレスポンスの内容を出力
      # puts JSON.pretty_generate(json_response)

      expect(json_response['main']['sentence']).to eq('吾輩は猫である。')
      expect(json_response).to have_key('parent')
      expect(json_response).to have_key('parent_parallel')
      expect(json_response).to have_key('children')
    end
  end
end
