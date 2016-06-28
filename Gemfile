source 'https://rubygems.org'

gem 'rails', '4.2.6'
gem 'sqlite3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

group :development, :test do
  gem 'byebug'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

##
## Customizations.
##

ruby '2.3.1'

gem 'bootstrap-sass', '~> 3.3', '>= 3.3.6'
gem 'font-awesome-rails', '~> 4.6', '>= 4.6.1.0'
gem 'bootswatch-rails', '~> 3.3', '>= 3.3.5'
gem 'kaminari', '~> 0.16.3'
# The following will be needed to get Bootstrap3 styling with Kaminari:
#   % rails g kaminari:views bootstrap3

gem 'puma', '~> 3.4'
gem 'sucker_punch', '~> 2.0', '>= 2.0.2'
gem 'fast_blank', '~> 1.0'

# Configuration and secrets management using ENV and the NEVER-COMMITTED
# config/application.yml file. After 'bundle install' execute this command:
#   % bundle exec figaro install
gem 'figaro', '~> 1.1', '>= 1.1.1'

# Cover images handling and processing.
gem 'carrierwave', '~> 0.11.2'
gem 'mini_magick', '~> 4.5', '>= 4.5.1'

group :development do
  gem 'bullet', '~> 5.1'
end

group :test do
  gem 'capybara', '~> 2.7.0'
  gem 'factory_girl_rails', '~> 4.7.0'
  gem 'poltergeist', '~> 1.9'

  # Nicer RSpec formatter. Add '--format Fivemat' to .rspec.
  gem 'fivemat', '~> 1.3', '>= 1.3.2'
end

group :production do
  # Cloud storage for covers.
  #gem 'fog-rackspace', '~> 0.1.1'
end

group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug', require: false
  gem 'pry-doc', require: false
  gem 'hirb', require: false
  gem 'rspec-rails', '~> 3.4.2'
end
