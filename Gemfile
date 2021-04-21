source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'

gem 'mysql2'

# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0', require: false

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false


# Capistrano

gem 'capistrano', '~> 3.10', require: false
gem 'capistrano-chruby', require: false
gem 'capistrano-dotenv', require: false
gem 'capistrano-passenger', require: false
gem "capistrano-rails", "~> 1.3", require: false
gem 'capistrano-yarn', require: false
gem 'capistrano-locally', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'capybara-screenshot'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'blacklight', '7.11.1'
gem 'geoblacklight', '3.3.0'
gem 'blacklight_advanced_search', '~> 7.0'
gem 'blacklight_range_limit', '~> 7.0'
gem 'chosen-rails' #  jquery multiselect plugin for advanced search

group :development, :test do
  gem 'solr_wrapper', '>= 3.1.0'
  gem 'sqlite3'
end

gem 'rsolr', '>= 1.0', '< 3'
gem 'bootstrap', '~> 4.0'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
gem 'devise'
gem 'devise-guests', '~> 0.6'
gem 'jquery-rails'

# Static Pages
gem 'high_voltage', '~> 3.1'
gem 'down', '~>5.0'
gem 'exception_notification', '~> 4.4.0'
gem 'sitemap_generator', '~> 6.1'
gem 'whenever', '~> 1.0'

# ENV
gem 'dotenv-rails'
