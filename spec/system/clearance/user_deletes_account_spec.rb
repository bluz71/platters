require "rails_helper"

RSpec.describe "User deletes account", type: :system do
  it "successfully" do
    create_user "user@example.com", "password9", "fred"
    log_in_with "user@example.com", "password9"

    click_on "Account"
    click_on "Delete account"
    expect_user_to_be_logged_out
    expect(page).to have_content "fred account has been deleted"

    log_in_with "user@example.com", "password9"
    expect(page).to have_content \
      "Incorrect log in credentials, or unconfirmed email address."
  end

  it "is invalid when trying to delete someone else's account" do
    create_user "user@example.com", "password9", "fred"
    user2 = FactoryBot.create(:user)
    log_in_with "user@example.com", "password9"

    visit edit_user_path(user2)
    expect(page).to have_content "You can only access your own account"
  end

  it "will also delete all the comments for the user" do
    user = FactoryBot.create(:user, email: "user@example.com", password: "password9")

    3.times { FactoryBot.create(:comment_for_artist, user: user, body: "Comment") }
    expect(Comment.count).to eq 3

    log_in_with "user@example.com", "password9"
    click_on "Account"
    click_on "Delete account"

    expect(Comment.count).to eq 0
  end
end
