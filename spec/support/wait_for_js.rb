# Information about waiting for JS requests to complete:
#   https://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara
#
# Important, call 'wait_for_js' in a feature test after invoking a JS action.

module WaitForJS
  def wait_for_js
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_js_requests?
    end
  end

  def finished_all_js_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

RSpec.configure do |config|
  config.include WaitForJS, type: :feature
end
