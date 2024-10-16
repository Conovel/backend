# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml

  config.openapi_root = "#{Rails.root}/swagger"

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.0',
      info: {
        title: 'Sentences API',
        version: '1.0.0',
        description: 'API documentation for V1'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3001/v1',
          description: 'Local server'
        },
        {
          url: 'https://conovel.jp/v1',
          description: 'Production server'
        }
      ]
    }
  }
end

Rails.application.routes.draw do
  # Swagger UI
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  def add_openapi_route(http_method, path, opts = {})
    full_path = path.gsub(/{(.*?)}/, ':\1')
    match full_path, to: "#{opts.fetch(:controller_name)}##{opts[:action_name]}", via: http_method
  end

  namespace :v1 do
    add_openapi_route 'GET', '/sentences/{sentence_id}', controller_name: 'sentences', action_name: 'show'
  end
end
