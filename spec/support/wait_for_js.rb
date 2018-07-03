# Information about waiting for JS requests to complete:
#   https://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara
#
# Important, call 'wait_for_js' in a feature test after invoking a JS action.

module WaitForJS
  def wait_for_js(repeat = 1)
    repeat.times do
      sleep(Capybara.default_max_wait_time)
    end
  end
end

RSpec.configure do |config|
  config.include WaitForJS, type: :system
end
