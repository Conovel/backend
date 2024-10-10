# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Sentences API', type: :request do
  let!(:sentence) { Sentence.create(sentence: '吾輩は猫である。') }
  let(:sentence_id) { sentence.id }

  path '/sentences/{sentence_id}' do
    get 'Retrieves a sentence' do
      tags 'Sentences'
      produces 'application/json'
      parameter name: :sentence_id, in: :path, type: :string

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
                   required: %w[sentence_id sentence created_at updated_at],
                   example: {
                     sentence_id: 1,
                     sentence: '吾輩は猫である。',
                     created_at: '2024-10-02T23:03:57.431Z',
                     updated_at: '2024-10-02T23:03:57.431Z'
                   }
                 }
               },
               required: ['main']

        let(:sentence_id) { sentence.id }
        run_test!
      end

      response '404', 'sentence not found' do
        let(:sentence_id) { 'invalid' }
        run_test!
      end
    end
  end
end
