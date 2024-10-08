# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sentences API', type: :request do
  let!(:sentence) { Sentence.create(sentence: '吾輩は猫である。') }
  let(:sentence_id) { sentence.id }

  describe 'GET /v1/sentences/:sentence_id' do
    before { get "/v1/sentences/#{sentence_id}" }

    it 'returns the sentence' do
      expect(json['main']['sentence']).to eq('吾輩は猫である。')
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
