module Features
  module ClearanceHelpers
    def reset_password_for(email)
      visit new_password_path
      fill_in "password_email", with: email
      click_on "Submit"
    end

    def log_in
      password = "password9"
      user = FactoryGirl.create(:user, password: password)
      log_in_with user.email, password
    end

    def log_in_with(email, password)
      visit log_in_path
      fill_in "session_email", with: email
      fill_in "session_password", with: password
      click_on "Submit"
    end

    def log_out
      click_on "Log out"
    end

    def sign_up_with(email, password, name)
      visit sign_up_path
      fill_in "user_email", with: email
      fill_in "user_password", with: password
      fill_in "user_name", with: name
      click_on "Submit"
    end

    def expect_user_to_be_logged_in(name)
      visit root_path
      expect(page).to have_content name
    end

    def expect_user_to_be_logged_out
      expect(page).to have_content I18n.t("layouts.application.sign_in")
    end

    def user_with_reset_password(name)
      user = FactoryGirl.create(:user, name: name)
      reset_password_for user.email
      user.reload
    end
  end
end

RSpec.configure do |config|
  config.include Features::ClearanceHelpers, type: :feature
end
