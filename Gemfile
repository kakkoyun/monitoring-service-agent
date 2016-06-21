# frozen_string_literal: true

source "https://rubygems.org"
ruby '2.2.5'

gem 'rack'
gem 'sinatra'
gem 'json'
gem 'rufus-scheduler'
gem 'usagewatch_ext'
gem 'faraday'

group :development do
  gem 'pry'

  # Deployment
  gem "capistrano"
  gem "capistrano-rbenv"
  gem "capistrano-bundler"
  gem 'capistrano-passenger'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'webmock'
end

group :production do
  gem 'passenger'
end

