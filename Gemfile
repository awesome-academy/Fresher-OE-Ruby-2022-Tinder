source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "3.0.2"

gem "active_model_serializers"
gem "activerecord-import"
gem "bcrypt", "3.1.13"
gem "bootsnap", ">= 1.4.4", require: false
gem "cancancan"
gem "caxlsx_rails"
gem "config"
gem "devise"
gem "execjs"
gem "faker"
gem "figaro"
gem "font-awesome-sass", "~> 6.2.0"
gem "i18n"
gem "i18n-js"
gem "jbuilder", "~> 2.7"
gem "mysql2", "~> 0.5"
gem "pagy"
gem "puma", "~> 5.0"
gem "rack-cors"
gem "rails", "~> 6.1.6", ">= 6.1.6.1"
gem "ransack"
gem "redis", "~> 4.8"
gem "roo"
gem "sass-rails", ">= 6"
gem "sidekiq"
gem "simplecov"
gem "simplecov-rcov"
gem "swagger-docs"
gem "therubyracer", platforms: :ruby
gem "whenever", require: false

group :development do
  gem "bullet"
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
end
group :development, :test do
  gem "factory_bot_rails"
  gem "pry", "~> 0.14.0"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "rubocop", "~> 1.26", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.14.0", require: false
  gem "shoulda-matchers", "~> 5.0"
  gem "turbolinks", "~> 5"
  gem "webpacker", "~> 5.0"
end
group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver", ">= 4.0.0.rc1"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)
