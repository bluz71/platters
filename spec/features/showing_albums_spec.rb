require "rails_helper"

RSpec.feature "Showing albums" do
  let(:genre)        { FactoryGirl.create(:genre, name: "Rock") }
  let(:artist)       { FactoryGirl.create(:artist, name: "ABC") }
  let(:release_date) { FactoryGirl.create(:release_date, year: 2013) }

  context "details" do
    let(:album) do
      FactoryGirl.create(:album_with_tracks, title: "XYZ", artist: artist,
                         genre: genre, release_date: release_date)
    end

    scenario "will include track count, release date year and genre" do
      visit artist_album_path(artist, album)

      expect(page).to have_content "XYZ by ABC"
      expect(page).to have_content "3 Tracks (Time 9:24)"
      expect(page).to have_content "2013"
      expect(page).to have_content "Rock"
    end
  end

  context "tracks will" do
    let(:album) do
      FactoryGirl.create(:album_with_tracks, title: "XYZ", artist: artist,
                         genre: genre, release_date: release_date)
    end

    before do
      FactoryGirl.create(:track, title: "Start", album: album)
      25.times do
        FactoryGirl.create(:track, album: album)
      end
      FactoryGirl.create(:track, title: "End", album: album)
    end

    scenario "display only the first twenty tracks by default" do
      visit artist_album_path(artist, album)

      expect(page).to have_selector "tr.visible td",   text: "Start"
      expect(page).to have_selector "tr.invisible td", text: "End"
    end

    scenario "display all tracks when 'show all tracks' is selected", js: true do
      visit artist_album_path(artist, album)
      click_on "Show all tracks"
      wait_for_js

      expect(page).to have_selector "tr.visible td", text: "Start"
      expect(page).to have_selector "tr.visible td", text: "End"
    end

    scenario "display the first twenty tracks when 'show less tracks' is selected", js: true do
      visit artist_album_path(artist, album)
      click_on "Show all tracks"
      wait_for_js
      click_on "Show less tracks"
      wait_for_js

      expect(page).not_to have_selector "tr.visible td", text: "End"
    end
  end
end
