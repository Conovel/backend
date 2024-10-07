# frozen_string_literal: true

# backend/spec/requests/sentences_spec.rb
require 'swagger_helper'

RSpec.describe 'Sentences API', type: :request do
  path '/v1/sentences/{sentence_id}' do
    get 'Retrieves a sentence by ID' do
      tags 'Sentences'
      produces 'application/json'
      parameter name: :sentence_id, in: :path, type: :integer

      response '200', 'sentence found' do
        schema type: :object,
               properties: {
                 main: {
                   type: :object,
                   properties: {
                     sentence_id: { type: :integer },
                     sentence: { type: :string },
                     created_at: { type: :string, format: 'date-time' },
                     updated_at: { type: :string, format: 'date-time' }
                   },
                   required: %w[sentence_id sentence created_at updated_at]
                 }
               }

        let!(:sentence) { Sentence.create(sentence: '吾輩は猫である。') }
        let(:sentence_id) { 1 }

        # run_test!
      end
    end
  end
end
