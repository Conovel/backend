# frozen_string_literal: true

# Sentences API
#
# No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
#
# The version of the OpenAPI document: 1.0.0
# Generated by: https://github.com/openapitools/openapi-generator.git

# sentences API
Rails.application.routes.draw do
  namespace :v1 do
    get 'sentences/:sentence_id', to: 'sentences#show'
  end

  # Swagger UI
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end
