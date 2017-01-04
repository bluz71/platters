require "rails_helper"
require "support/features/clearance_helpers"

RSpec.feature "Visitor signs up" do
  scenario "by navigating to the page" do
    visit log_in_path

    click_link I18n.t("sessions.form.sign_up")

    expect(current_path).to eq sign_up_path
  end

  scenario "with valid email and password and then confirms their email" do
    ActionMailer::Base.deliveries.clear
    sign_up_with "valid@example.com", "password9", "fred"

    expect(page).to have_content "Hello fred, in order to complete your sign up, "\
                                 "please follow the instructions in the email "\
                                 "that was just sent to you."
    expect_user_to_be_logged_out
    email = find_email!("valid@example.com")
    expect(email.subject).to eq "Platters email confirmation"
    expect(email).to have_body_text "In order to complete your Platters sign up, "\
                                    "please click the following confirmation link:"
    click_first_link_in_email(email)
    expect(page).to have_content "Welcome fred, you have now completed the sign up process"
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
