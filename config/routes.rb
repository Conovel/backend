# frozen_string_literal: true

# Sentences API
#
# No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
#
# The version of the OpenAPI document: 1.0.0
# Generated by: https://github.com/openapitools/openapi-generator.git

# sentences API
Rails.application.routes.draw do
  def add_openapi_route(http_method, path, opts = {})
    full_path = path.gsub(/{(.*?)}/, ':\1')
    match full_path, to: "#{opts.fetch(:controller_name)}##{opts[:action_name]}", via: http_method
  end

  namespace :v1 do
    add_openapi_route 'GET', '/sentences/{sentence_id}', controller_name: 'sentences', action_name: 'show'
  end

  # Swagger UI
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end
