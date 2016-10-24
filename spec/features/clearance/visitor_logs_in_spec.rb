require "rails_helper"
require "support/features/clearance_helpers"

RSpec.feature "Visitor logs in" do
  scenario "with valid email and password" do
    create_user "user@example.com", "password9", "fred"
    log_in_with "user@example.com", "password9"

    expect_user_to_be_logged_in "fred"
  end

  scenario "with valid mixed-case email and password " do
    create_user "user.name@example.com", "password9", "fred"
    log_in_with "User.Name@example.com", "password9"

    expect_user_to_be_logged_in "fred"
  end

  scenario "tries with invalid password" do
    create_user "user@example.com", "password9", "fred"
    log_in_with "user@example.com", "wrong_password9"

    expect_page_to_display_log_in_error
    expect_user_to_be_logged_out
  end

  scenario "tries with invalid email" do
    log_in_with "unknown.email@example.com", "password9"

    expect_page_to_display_log_in_error
    expect_user_to_be_logged_out
  end

  private

    def expect_page_to_display_log_in_error
      expect(page.body).to include(
        I18n.t("flashes.failure_after_create", sign_up_path: sign_up_path)
      )
    end
end
