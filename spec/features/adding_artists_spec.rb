require "rails_helper"

RSpec.feature "Adding artists" do
  let!(:artist) { FactoryGirl.create(:artist, name: "ABC") }

  context "when submitting" do
    before do
      visit artists_path
      click_on "Artist"
    end

    scenario "with valid attributes" do
      fill_in "Name", with: "XYZ"
      fill_in "Wikipedia", with: "ZYZ"
      fill_in "Website", with: "http://www.xyz.net"
      fill_in "Description", with: "XYZ description"
      click_on "Submit"

      artist = Artist.find_by(name: "XYZ")
      expect(current_path).to eq artist_path(artist)
      expect(page).to have_content "XYZ has been created"
      expect(page).to have_title "XYZ"
      expect(page).to have_selector "div#artist h1", text: "XYZ"
      expect(page).to have_selector "div#artist .description", text: "XYZ description"
      expect(page).to have_link "Wikipedia", href: "https://www.wikipedia.org/wiki/ZYZ"
      expect(page).to have_link "xyz.net", href: "http://www.xyz.net"
    end

    scenario "with blank name" do
      click_on "Submit"

      expect(page).to have_content "Artist could not be created"
      expect(page).to have_content "Name can't be blank"
    end

    scenario "with existing artist name" do
      fill_in "Name", with: "ABC"
      click_on "Submit"

      expect(page).to have_content "Artist could not be created"
      expect(page).to have_content "Name has already been taken"
    end
  end

  scenario "when cancelled goes back" do
    40.times { FactoryGirl.create(:artist) }
    FactoryGirl.create(:artist, name: "XYZ")

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
end
