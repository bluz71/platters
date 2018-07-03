require "rails_helper"

RSpec.describe "User logs out", type: :system do
  it "logs out" do
    log_in
    log_out

    expect_user_to_be_logged_out
  end
end
