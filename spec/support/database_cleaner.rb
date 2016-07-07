# Information about RSpec, Capybara, JS tests and database cleaning:
#   http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/
#
# Important, transactional_fixtures in spec/rails_helper.rb must be disabled:
#   config.use_transactional_fixtures = false

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
 
  config.before(:each) do
    # The transaction cleaning strategy will be used for most tests.
    DatabaseCleaner.strategy = :transaction
  end
 
  config.before(:each, js: true) do
    # The truncation strategy is required for Javascript tests.
    DatabaseCleaner.strategy = :truncation
  end
 
  config.before(:each) do
    DatabaseCleaner.start
  end
 
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
