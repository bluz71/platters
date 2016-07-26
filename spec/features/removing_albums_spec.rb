require "rails_helper"

RSpec.feature "Removing albums" do
  let!(:artist)        { FactoryGirl.create(:artist, name: "ABC") }
  let!(:release_date)  { FactoryGirl.create(:release_date, year: 2000) }
  let!(:album) do
    FactoryGirl.create(:album, title: "Album",
                       artist: artist, release_date: release_date)
  end

  context "from album page" do
    scenario "successfully" do
      visit artist_album_path(artist, album)
      click_on "Remove"

      expect(current_path).to eq artist_path(artist)
      expect(page).to have_content "Album has been removed"
      expect(page).not_to have_selector "div.album h2", text: "Album"
    end
  end

  context "from artist page", js: true do
    scenario "successfully with JavaScript" do
      visit artist_path(artist)

      # Click on the 2nd Remove link, first is Remove Artist, 2nd is Remove Album.
      within ".album" do
        click_on "Remove"
        wait_for_js
      end

      expect(current_path).to eq artist_path(artist)
      expect(page).to have_content "Album has been removed"
      expect(page).not_to have_selector "div.album h2", text: "Album"
    end
  end
end
