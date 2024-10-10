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
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

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

    # Add the path of the service object
    config.autoload_paths += %W[#{config.root}/app/services]
  end
end

module ApiDemo
  # Application class for the ApiDemo module.
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
