require "rails_helper"

RSpec.feature "Adding artists" do
  context "when submitting" do
    before do
      visit artists_path
      click_on "Artist"
    end

    scenario "with valid attributes" do
      fill_in "Name", with: "XYZ"
      fill_in "Wikipedia", with: "XYZ"
      fill_in "Website", with: "http://www.xyz.net"
      fill_in "Description", with: "XYZ description"
      click_on "Submit"

      artist = Artist.find_by(name: "XYZ")
      expect(current_path).to eq artist_path(artist)
      expect(page).to have_content "XYZ has been created"
      expect(page).to have_title "XYZ"
      expect(page).to have_selector "div#artist h1", text: "XYZ"
      expect(page).to have_selector "div#artist .description", text: "XYZ description"
      expect(page).to have_link "Wikipedia", href: "https://www.wikipedia.org/wiki/XYZ"
      expect(page).to have_link "xyz.net", href: "http://www.xyz.net"
    end

    scenario "with blank name" do
      click_on "Submit"

      expect(page).to have_content "Artist could not be created"
      expect(page).to have_content "Name can't be blank"
      expect(page).to have_selector "div.page-header h1", text: "Add Artist"
    end

    scenario "with existing artist name" do
      FactoryGirl.create(:artist, name: "ABC")
      fill_in "Name", with: "ABC"
      click_on "Submit"

      expect(page).to have_content "Artist could not be created"
      expect(page).to have_content "Name has already been taken"
    end
  end

  context "when cancelled" do
    before do
      25.times { FactoryGirl.create(:artist) }
      FactoryGirl.create(:artist, name: "XYZ")
    end

    scenario "goes back" do
      visit artists_path
      click_on "Next"
      expect(page).not_to have_selector "div.artist h2", text: "ABC"
      expect(page).to have_selector "div.artist h2", text: "XYZ"
      expect(current_url).to eq("http://www.example.com/?page=2")

      click_on "Artist"
      expect(current_url).not_to eq("http://www.example.com/?page=2")

      click_on "Cancel"
      expect(current_url).to eq("http://www.example.com/?page=2")
    end

    scenario "goes back after validation error" do
      visit artists_path
      click_on "Next"
      expect(page).not_to have_selector "div.artist h2", text: "ABC"
      expect(page).to have_selector "div.artist h2", text: "XYZ"
      expect(current_url).to eq("http://www.example.com/?page=2")

      click_on "Artist"
      click_on "Submit"
      click_on "Cancel"
      expect(current_path).to eq(artists_path)
    end
  end
end
