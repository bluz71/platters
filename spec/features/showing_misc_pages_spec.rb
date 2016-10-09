require "rails_helper"

RSpec.feature "Showing misc" do
  context "home page" do
    scenario "contains a jumbotron" do
      visit root_path
      expect(page).to have_content "An album collection web application developed using modern web technologies."
    end

    scenario "contains a technologies section" do
      visit root_path
      expect(page).to have_content "Prime technologies used by the Platters application."
    end

    scenario "contains newest albums section" do
      artist = FactoryGirl.create(:artist)
      FactoryGirl.create(:album, title: "Album-1", artist: artist, year: Date.current.year)
      FactoryGirl.create(:album, title: "Album-2", artist: artist, year: Date.current.year)
      FactoryGirl.create(:album, title: "Album-3", artist: artist, year: Date.current.year)

      visit root_path
      expect(page).to have_content "Album-1"
      expect(page).to have_content "Album-2"
      expect(page).to have_content "Album-3"
    end

    scenario "when navigating by the brand icon" do
      visit artists_path
      click_on "platters"
      expect(page).to have_content "An album collection web application developed using modern web technologies."
    end
  end

  context "about page" do
    scenario "contains content" do
      visit about_path
      expect(page).to have_content "This application, Platters, is an example web application"
    end

    scenario "when navigating by the navigation footer" do
      visit artists_path
      click_on "About"
      expect(page).to have_content "This application, Platters, is an example web application"
    end

    scenario "does not list contact email details when a user is logged out" do
      visit about_path
      expect(page).not_to have_content "If you have any comments"
    end

    scenario "does list contact email details when a user is logged in"
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
