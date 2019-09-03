RSpec.configure do |config|
  include ActiveJob::TestHelper

  config.around(:each, :perform_enqueued) do |example|
    perform_enqueued_jobs do
      example.run
    end
  end
end
