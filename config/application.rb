# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Backend
  # Application is the main class for the Rails application configuration.
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Asia/Tokyo'
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Add session middleware
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, key: ENV.fetch('SESSION_KEY', nil),
                                                                secure: Rails.env.production?

    # 必要ならホスト制限
    config.hosts << 'conovel.jp'

    # 本番は SSL を強制（X-Forwarded-Proto が正しく来る前提）
    config.force_ssl = true if Rails.env.production?

    # original url setting
    config.origin_url = if Rails.env.production?
                          ENV.fetch('PRODUCTION_ORIGIN_URL', 'https://conovel.jp')
                        else
                          ENV.fetch('DEVELOPMENT_ORIGIN_URL', 'http://localhost:3000')
                        end

    # Configuration before Rails is initialized
    config.before_initialize do
      # Add load path (for frozen errors)
      config.paths.add 'app/channels', eager_load: true
      config.paths.add 'app/controllers', eager_load: true
      config.paths.add 'app/controllers/concerns', eager_load: true
      config.paths.add 'app/jobs', eager_load: true
      config.paths.add 'app/mailers', eager_load: true
      config.paths.add 'app/models', eager_load: true
      config.paths.add 'app/models/concerns', eager_load: true
    end

    # Add custom error directory to autoload and eager load paths
    config.paths.add 'app/errors', eager_load: true
  end
end
