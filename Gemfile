source "https://rubygems.org"

gem "rails", "6.0.2.2"
gem "webpacker", "~> 4.x"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.7"
gem "rack-cors"

group :development, :test do
  gem "byebug"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.0.5"
end

##
## Customizations.
##

ruby "2.6.2"

gem "pg"
# Note, if postgres is installed in an out-of-the way place (e.g
# /usr/local/opt/postgresql@10 as happens for 'brew install postgresql@10')
# then we need to inform the pg gem of this location when it comes time for
# it to build its native extension.
#
# For Gemfile usages of 'pg' do the following:
#   % bundle config build.pg --with-pg-config=/usr/local/opt/postgresql@10/bin/pg_config
#
# For plain gem usage do the following:
#   % gem install pg -v 0.19.0 -- --with-pg-config=/usr/local/opt/postgresql@10/bin/pg_config

gem "bootsnap", ">= 1.4.2", require: false
gem "font-awesome-rails", "~> 4.7", ">= 4.7.0.4"
gem "friendly_id", "~> 5.2"
gem "kaminari", "~> 1.1", ">= 1.1.1"
# The following will be needed to get Bootstrap3 styling with Kaminari:
#   % rails g kaminari:views bootstrap3
gem "clearance", "~> 1.16", ">= 1.16.2"
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

gem "puma", "~> 4.3.3"
gem "sidekiq", "~> 5.2", ">= 5.2.3"
gem "fast_blank", "~> 1.0"
gem "oj", "~> 3.9"
gem "redis", "~> 4.0"
gem "invisible_captcha", "~> 0.9.2"
gem "faker", "~> 1.7", ">= 1.7.1"
gem "local_time", "~> 2.0"
gem "rinku", "~> 2.0", ">= 2.0.6"
gem "obscenity", "~> 1.0", ">= 1.0.2"
gem "rack-attack", "~> 5.4", ">= 5.4.2"
gem "jwt", "~> 2.1"

# Configuration and secrets management using ENV and the NEVER-COMMITTED
# config/application.yml file. After 'bundle install' execute this command:
#   % bundle exec figaro install
gem "figaro", "~> 1.1", ">= 1.1.1"

# Cover images handling and processing.
gem "carrierwave", "~> 1.3", ">= 1.3.1"
gem "mini_magick", "~> 4.9", ">= 4.9.5"

# Nicer Rails console output for ActiveRecord results.
gem "hirb", require: false

# Error reporting. Note, this will only be active in production.
gem "rollbar", "~> 2.22", ">= 2.22.1"

group :development do
  gem "mina", "~> 1.2", ">= 1.2.3", require: false
  gem "bullet", "~> 6.0", ">= 6.0.2"
  gem "rack-mini-profiler", "~> 0.10.1", require: false
  gem "brakeman", require: false # be brakeman -f plain
  gem "lol_dba", require: false  # be lol_dba db:find_indexes
  gem "rubocop", require: false  # be rubocop
  gem "standard", require: false # be standardrb
end

group :test do
  gem "capybara", "~> 3.28"
  gem "selenium-webdriver"
  gem "factory_bot_rails", "~> 4.8", ">= 4.8.2"
  gem "email_spec", "~> 2.2"

  # Launch a browser from within feature specs when invoking the Capybara
  # 'save_and_open_page' method.
  gem "launchy", "~> 2.4", ">= 2.4.3"

  # Nicer RSpec formatter. Add '--format Fivemat' to .rspec.
  gem "fivemat", "~> 1.3", ">= 1.3.2"
end

group :production do
  # Cloud storage for covers.
  gem "fog-rackspace", "~> 0.1.6"
  # Tame log policy in production.
  gem "lograge", "~> 0.11.2"
  # Performance monitoring.
  gem "skylight", "~> 4.1", ">= 4.1.2"
end

group :development, :test do
  gem "pry-rails"
  gem "pry-byebug"
  gem "pry-doc", require: false
  gem "rspec-rails", "~> 3.8", ">= 3.8.2"
end
