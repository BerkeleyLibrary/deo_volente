# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.5'

gem 'bootsnap', require: false
gem 'dartsass-sprockets', '~> 3.0'
gem 'importmap-rails'
gem 'jbuilder'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.3', '>= 7.1.3.4'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'faraday'
gem 'faraday-multipart'
gem 'good_job'
gem 'omniauth'
gem 'omniauth-cas'
gem 'omniauth-rails_csrf_protection'
gem 'pg'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]
  gem 'rspec-rails'
  gem 'rubocop-capybara', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
  gem 'webmock'
end

group :development do
  # Use console on exceptions pages [h ttps://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  gem 'ruby-lsp'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end
