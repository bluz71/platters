require "rails_helper"

RSpec.describe "Visitor updates password", type: :system do
  it "with valid password" do
    user = user_with_reset_password("fred")
    update_password(user, "newpassword")

    expect_user_to_be_logged_in "fred"
  end

  it "logs in with new password" do
    user = user_with_reset_password("fred")
    update_password(user, "newpassword")
    log_out
    log_in_with(user.email, "newpassword")

    expect_user_to_be_logged_in "fred"
  end

  it "tries with a blank password" do
    user = user_with_reset_password("fred")
    visit_password_reset_page_for(user)
    change_password_to ""

    expect(page).to have_content I18n.t("flashes.failure_after_update")
    expect_user_to_be_logged_out
  end

  it "tries with a short password" do
    user = user_with_reset_password("fred")
    visit_password_reset_page_for(user)
    change_password_to "short"

    expect(page).to have_content I18n.t("flashes.failure_after_update")
    expect_user_to_be_logged_out
  end

  private

  def update_password(user, password)
    visit_password_reset_page_for user
    change_password_to password
  end

  def visit_password_reset_page_for(user)
    visit edit_user_password_path(user_id: user,
                                  token: user.confirmation_token)
  end

  def change_password_to(password)
    fill_in "password_reset_password", with: password
    click_on "Submit"
  end
end
