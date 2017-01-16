require "rails_helper"
require "support/features/clearance_helpers"

RSpec.feature "Showing misc" do
  context "home page" do
    scenario "contains a jumbotron" do
      visit root_path
      expect(page).to have_content \
        "An album collection web application developed using modern web technologies."
    end

    scenario "contains a technologies section" do
      visit root_path
      expect(page).to have_content "Prime technologies used by the Platters application."
    end

    scenario "contains album of the day section" do
      artist = FactoryGirl.create(:artist)
      release_date = FactoryGirl.create(:release_date)
      FactoryGirl.create(:album, artist: artist, release_date: release_date)

      visit root_path
      expect(page).to have_content "Album of the day"
    end

    scenario "contains newest albums section" do
      artist = FactoryGirl.create(:artist)
      FactoryGirl.create(:album, title: "Album-1", artist: artist,
                         year: Date.current.year)
      FactoryGirl.create(:album, title: "Album-2", artist: artist,
                         year: Date.current.year)
      FactoryGirl.create(:album, title: "Album-3", artist: artist,
                         year: Date.current.year)

      visit root_path
      expect(page).to have_content "Album-1"
      expect(page).to have_content "Album-2"
      expect(page).to have_content "Album-3"
    end

    scenario "contains newest comments section" do
      artist = FactoryGirl.create(:artist)
      FactoryGirl.create(:comment_for_artist, commentable: artist,
                         body: "Eleventh comment")
      for i in 0..9
        FactoryGirl.create(:comment_for_artist, commentable: artist,
                           body: "Comment #{i}")
      end

      visit root_path
      comments = page.all(".comment")
      expect(comments.size).to eq 10
      expect(page).to have_content "New Comments"
      expect(page).to have_selector "div.comment p", text: "Comment 0"
      expect(page).to have_selector "div.comment p", text: "Comment 9"
      expect(page).not_to have_content "Eleventh comment"
    end

    scenario "when navigating by the brand icon" do
      visit artists_path
      click_on "platters"
      expect(page).to have_content \
        "An album collection web application developed using modern web technologies."
    end
  end

  context "about page" do
    scenario "contains content" do
      visit about_path
      expect(page).to have_content \
        "This application, Platters, is an example web application"
    end

    scenario "when navigating by the navigation footer" do
      visit artists_path
      click_on "About"
      expect(page).to have_content \
        "This application, Platters, is an example web application"
    end

    scenario "does not list contact email details when a user is logged out" do
      visit about_path
      expect(page).not_to have_content "If you have any comments"
    end

    scenario "does list contact email details when a user is logged in" do
      create_user "user@example.com", "password9", "fred"
      log_in_with "user@example.com", "password9"
      visit about_path
      expect(page).to have_content "If you have any comments"
    end
  end

  context "details page" do
    scenario "contains content" do
      visit details_path
      expect(page).to have_content "Core technolgies"
    end

    scenario "when navigating by the navigation footer" do
      visit artists_path
      click_on "Details"
      expect(page).to have_content "Core technolgies"
    end
  end
end
