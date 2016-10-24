require "rails_helper"
require "support/features/clearance_helpers"

RSpec.feature "Visitor signs up" do
  scenario "by navigating to the page" do
    visit log_in_path

    click_link I18n.t("sessions.form.sign_up")

    expect(current_path).to eq sign_up_path
  end

  scenario "with valid email and password" do
    sign_up_with "valid@example.com", "password9", "fred"

    expect(page).to have_content "Welcome fred, you have signed up successfully"
    expect_user_to_be_logged_in("fred")
  end

  scenario "tries with invalid email" do
    sign_up_with "invalid_email", "password9", "fred"

    expect(page).to have_content "Account could not be created"
    expect_user_to_be_logged_out
  end

  scenario "tries with blank password" do
    sign_up_with "valid@example.com", "", "fred"

    expect(page).to have_content "Account could not be created"
    expect_user_to_be_logged_out
  end

  scenario "without name" do
    sign_up_with "valid@example.com", "password9", ""

    expect(page).to have_content "Account could not be created"
    expect_user_to_be_logged_out
  end
end
