source 'https://rubygems.org'

gem 'rails', '5.2.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'rack-cors'

group :development, :test do
  gem 'byebug'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

##
## Customizations.
##

ruby '2.5.1'

gem 'pg'
# Note, if postgres is installed in an out-of-the way place (e.g
# /usr/local/opt/postgresql@9.6 as happens for 'brew install postgresql@9.6')
# then we need to inform the pg gem of this location when it comes time for
# it to build its native extension.
#
# For Gemfile usages of 'pg' do the following:
#   % bundle config build.pg --with-pg-config=/usr/local/opt/postgresql@9.6/bin/pg_config
#
# For plain gem usage do the following:
#   % gem install pg -v 0.19.0 -- --with-pg-config=/usr/local/opt/postgresql@9.6/bin/pg_config

gem 'bootsnap', '~> 1.3', require: false
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.7'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.4'
gem 'bootswatch-rails', '~> 3.3', '>= 3.3.5'
gem 'friendly_id', '~> 5.2'
gem 'kaminari', '~> 0.17.0'
# The following will be needed to get Bootstrap3 styling with Kaminari:
#   % rails g kaminari:views bootstrap3
gem 'clearance', '~> 1.16'
# Clearance generators:
#   % rails g clearance:install
#   % rake db:migrate
#   % rails g clearance:views
#   % rails g clearance:routes
#   % rails g clearance:specs
# Helpful Clearance pages:
#   https://www.sitepoint.com/simple-rails-authentication-with-clearance/
#   http://everydayrails.com/2016/01/23/clearance-rails-authentication.html
#   https://robots.thoughtbot.com/email-confirmation-with-clearance

gem 'puma', '~> 3.11', '>= 3.11.4'
gem 'sidekiq', '~> 5.0'
gem 'fast_blank', '~> 1.0'
gem 'oj', '~> 3.3', '>= 3.3.8'
gem 'redis-rails', '~> 5.0', '>= 5.0.2'
gem 'invisible_captcha', '~> 0.9.2'
gem 'faker', '~> 1.7', '>= 1.7.1'
gem 'local_time', '~> 2.0'
gem 'rinku', '~> 2.0', '>= 2.0.2'
gem 'obscenity', '~> 1.0', '>= 1.0.2'
gem 'rack-attack', '~> 5.0', '>= 5.0.1'

# Configuration and secrets management using ENV and the NEVER-COMMITTED
# config/application.yml file. After 'bundle install' execute this command:
#   % bundle exec figaro install
gem 'figaro', '~> 1.1', '>= 1.1.1'

# Cover images handling and processing.
gem 'carrierwave', '~> 1.2', '>= 1.2.2'
gem 'mini_magick', '~> 4.8'

# Nicer Rails console output for ActiveRecord results.
gem 'hirb', require: false

# Error reporting. Note, this will only be active in production.
gem 'rollbar', '~> 2.14'

group :development do
  gem 'bullet', '~> 5.7', '>= 5.7.5'
  gem 'rack-mini-profiler', '~> 0.10.1', require: false
  gem 'brakeman', require: false
  gem 'rubocop', require: false
end

group :test do
  gem 'capybara', '~> 2.16', '>= 2.16.1'
  gem 'capybara-selenium', '~> 0.0.6'
  gem 'factory_bot_rails', '~> 4.8', '>= 4.8.2'
  gem 'email_spec', '~> 2.1'

  # Launch a browser from within feature specs when invoking the Capybara
  # 'save_and_open_page' method.
  gem 'launchy', '~> 2.4', '>= 2.4.3'

  # Nicer RSpec formatter. Add '--format Fivemat' to .rspec.
  gem 'fivemat', '~> 1.3', '>= 1.3.2'
end

group :production do
  # Cloud storage for covers.
  gem 'fog-rackspace', '~> 0.1.5'
  # Tame log policy in production.
  gem 'lograge', '~> 0.10.0'
  # Performance monitoring.
  gem 'skylight', '~> 1.2', '>= 1.2.2'
end

group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-doc', require: false
  gem 'rspec-rails', '~> 3.7', '>= 3.7.2'
end
