# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Pets API', type: :request do
  path '/v1/pets' do
    get 'Retrieves all pets' do
      tags 'Pets'
      produces 'application/json'

      response '200', 'pets found' do
        run_test!
      end
    end
  end
end
