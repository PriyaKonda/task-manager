source "https://rubygems.org"

gem "rails", "~> 8.0.4"
gem "propshaft"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem 'mongoid'
gem 'mongoid_rails_migrations'
gem "bcrypt", "~> 3.1.7"
gem "mailcatcher"
gem 'dotenv-rails'

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "bootsnap", require: false
gem "ably-rest"
# gem ably
# gem "ably-ruby", require: false
gem "kamal", require: false

gem "thruster", require: false

gem 'sidekiq'
gem 'redis'
gem 'mail'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false

  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem 'letter_opener'
  gem 'letter_opener_web'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "rails-controller-testing"
end
