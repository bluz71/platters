require "rails_helper"
require "support/system/clearance_helpers"

RSpec.describe "Showing misc", type: :system do
  context "home page" do
    it "contains a jumbotron" do
      visit root_path
      expect(page).to have_content \
        "An album collection web application developed using modern web technologies."
    end

    it "contains a technologies section" do
      visit root_path
      expect(page).to have_content "Prime technologies used by the Platters application."
    end

    it "contains album of the day section" do
      artist = FactoryBot.create(:artist)
      release_date = FactoryBot.create(:release_date)
      FactoryBot.create(:album, artist: artist, release_date: release_date)

      visit root_path
      expect(page).to have_content "Album of the day"
    end

    it "contains newest albums section" do
      artist = FactoryBot.create(:artist)
      FactoryBot.create(
        :album, title: "Album-1", artist: artist, year: Date.current.year
      )
      FactoryBot.create(
        :album, title: "Album-2", artist: artist, year: Date.current.year
      )
      FactoryBot.create(
        :album, title: "Album-3", artist: artist, year: Date.current.year
      )

      visit root_path
      expect(page).to have_content "Album-1"
      expect(page).to have_content "Album-2"
      expect(page).to have_content "Album-3"
    end

    it "contains newest comments section" do
      artist = FactoryBot.create(:artist)
      FactoryBot.create(
        :comment_for_artist, commentable: artist, body: "Eleventh comment"
      )
      (0..9).each do |i|
        FactoryBot.create(
          :comment_for_artist, commentable: artist, body: "Comment #{i}"
        )
      end

      visit root_path
      comments = page.all(".comment")
      expect(comments.size).to eq 10
      expect(page).to have_content "New Comments"
      expect(page).to have_selector "div.comment p", text: "Comment 0"
      expect(page).to have_selector "div.comment p", text: "Comment 9"
      expect(page).not_to have_content "Eleventh comment"
    end

    it "when navigating by the brand icon" do
      visit artists_path
      click_on "platters"
      expect(page).to have_content \
        "An album collection web application developed using modern web technologies."
    end
  end

  context "about page" do
    it "contains content" do
      visit about_path
      expect(page).to have_content \
        "This application, Platters, is an example web application"
    end

    it "when navigating by the navigation footer" do
      visit artists_path
      click_on "About"
      expect(page).to have_content \
        "This application, Platters, is an example web application"
    end

    it "does not list contact email details when a user is logged out" do
      visit about_path
      expect(page).not_to have_content "If you have any comments"
    end

    it "does list contact email details when a user is logged in" do
      create_user "user@example.com", "password9", "fred"
      log_in_with "user@example.com", "password9"
      visit about_path
      expect(page).to have_content "If you have any comments"
    end
  end

  context "details page" do
    it "contains content" do
      visit details_path
      expect(page).to have_content "Core technologies"
    end

    it "when navigating by the navigation footer" do
      visit artists_path
      click_on "Details"
      expect(page).to have_content "Core technologies"
    end
  end
end
