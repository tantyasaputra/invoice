# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.1'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.3', '>= 7.1.3.3'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'aasm'
gem 'active_model_serializers'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false
gem 'httparty'
gem 'jwt'
gem 'puma', '>= 5.0'
gem 'rack-cors'
gem 'swagger-blocks'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'rubocop', require: false
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
