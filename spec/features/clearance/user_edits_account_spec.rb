require "rails_helper"
require "support/features/clearance_helpers"

RSpec.feature "User edits account" do
  before do
    create_user "user@example.com", "password9", "fred"
  end

  scenario "with valid change name" do
    log_in_with "user@example.com", "password9"

    click_on "Account"
    fill_in "Name", with: "john"
    fill_in "Password", with: "password9"
    click_on "Update"
    log_out

    log_in_with "user@example.com", "password9"
    expect_user_to_be_logged_in("john")
  end

  scenario "with valid change password" do
    log_in_with "user@example.com", "password9"

    click_on "Account"
    fill_in "Password", with: "password8"
    click_on "Update"
    log_out

    log_in_with "user@example.com", "password9"
    expect(page).to have_content \
      "Incorrect log in credentials, or unconfirmed email address."
    log_in_with "user@example.com", "password8"
    expect_user_to_be_logged_in("fred")
  end

  scenario "is invalid when name is not unique" do
    FactoryBot.create(:user, name: "john")
    log_in_with "user@example.com", "password9"

    click_on "Account"
    fill_in "Name", with: "john"
    fill_in "Password", with: "password9"
    click_on "Update"

    expect(page).to have_content "Your account could not be updated"
    expect(page).to have_content "Name has already been taken"
  end

  scenario "with invalid short name" do
    log_in_with "user@example.com", "password9"

    click_on "Account"
    fill_in "Name", with: "www"
    fill_in "Password", with: "password9"
    click_on "Update"

    expect(page).to have_content "Your account could not be updated"
    expect(page).to have_content "Name is too short"
  end

  scenario "with invalid long name" do
    log_in_with "user@example.com", "password9"

    click_on "Account"
    fill_in "Name", with: "qqqwwweeerrrtttyyyuuu"
    fill_in "Password", with: "password9"
    click_on "Update"

    expect(page).to have_content "Your account could not be updated"
    expect(page).to have_content "Name is too long"
  end

  scenario "with blank password" do
    log_in_with "user@example.com", "password9"

    click_on "Account"
    fill_in "Password", with: ""
    click_on "Update"

    expect(page).to have_content "Your account could not be updated"
    expect(page).to have_content "Password can't be blank"
  end

  scenario "with short password" do
    log_in_with "user@example.com", "password9"

    click_on "Account"
    fill_in "Password", with: "foo"
    click_on "Update"

    expect(page).to have_content "Your account could not be updated"
    expect(page).to have_content "Password is too short"
  end
end
