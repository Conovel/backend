# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.4'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.8', '>= 7.0.8.1'

# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

# These gems are added to ensure compatibility with future versions of Ruby (3.4.0 and later),
# as they will no longer be part of the standard library.
gem 'base64'
gem 'bigdecimal'
gem 'mutex_m'

# Use rubocop as a linter/code formatter
gem 'rubocop', '~> 1.66', require: false

# Use overcommit as a Git hook management
gem 'overcommit', '~> 0.60.0'

# Used as a CORS settings
gem 'rack-cors'

# Use composite_primary_keys as a composite primary key
gem 'composite_primary_keys'

# Used to Logical deletion
gem 'paranoia', '~> 2.4'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  # Uses rspec-rails as a test framework
  gem 'rspec-rails', '~> 7.0.0'

  # Used to integrate rspec and openAPI
  gem 'rswag'

  # Used to create test data
  gem 'factory_bot_rails'

  # Use ActiveRecord database for cleanup
  gem 'database_cleaner-active_record'

  # Use dotenv-rails to manage environment variables
  gem 'dotenv-rails'

  # Supports OAuth authentication through multiple providers
  gem 'omniauth'

  # Protecting against CSRF attacks when using OmniAuth in Rails applications
  gem 'omniauth-rails_csrf_protection'

  # An OmniAuth strategy for authentication using Google's OAuth 2.0 service.
  gem 'omniauth-google-oauth2'

  # Encode and decode JSON Web Tokens (JWT)
  gem 'jwt'
end
group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Help to kill N+1 queries and unused eager loading
  gem 'bullet'
end
