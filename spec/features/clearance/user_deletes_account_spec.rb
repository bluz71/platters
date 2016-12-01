require "rails_helper"
require "support/features/clearance_helpers"

RSpec.feature "User deletes account" do
  scenario "successfully" do
    create_user "user@example.com", "password9", "fred"
    log_in_with "user@example.com", "password9"

    click_on "Account"
    click_on "Delete account"
    expect_user_to_be_logged_out
    expect(page).to have_content "fred account has been deleted"

    log_in_with "user@example.com", "password9"
    expect(page).to have_content "Incorrect log in credentials, or unconfirmed email address."
  end

  scenario "is invalid when trying to delete someone else's account" do
    create_user "user@example.com",  "password9", "fred"
    user2 = FactoryGirl.create(:user)
    log_in_with "user@example.com", "password9"

    visit edit_user_path(user2)
    expect(page).to have_content "You can only access your own account"
  end

  scenario "will delete all the comments for the user"
  # and update the timestamps for the artists/albums effected.
end
