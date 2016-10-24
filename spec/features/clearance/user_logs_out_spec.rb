require "rails_helper"
require "support/features/clearance_helpers"

RSpec.feature "User logs out" do
  scenario "logs out" do
    log_in
    log_out

    expect_user_to_be_logged_out
  end
end
