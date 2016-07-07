require "rails_helper"

RSpec.feature "Listing albums" do
  let(:genre)         { FactoryGirl.create(:genre, name: "Rock") }
  let(:artist)        { FactoryGirl.create(:artist, name: "ABC") }
  let(:artist2)       { FactoryGirl.create(:artist, name: "CBA") }
  let(:release_date)  { FactoryGirl.create(:release_date, year: 2000) }
  let(:release_date2) { FactoryGirl.create(:release_date, year: 2010) }

  before do
    FactoryGirl.create(:album, title: "ABC",
                       artist: artist, genre: genre,
                       release_date: release_date)
    25.times do
      FactoryGirl.create(:album, artist: artist2, release_date: release_date)
    end
    FactoryGirl.create(:album, title: "XYZ",
                       artist: artist, genre: genre,
                       release_date: release_date2)
  end

  context "for all artists" do
    scenario "will be alpabetized" do
      visit albums_path

      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).not_to have_selector "div.album h2", text: "XYZ"
    end

    scenario "will successfully paginate" do
      visit albums_path
      click_on "Next"

      expect(page).not_to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end
  end

  context "for a certain artist" do
    scenario "will display only their albums" do
      visit artist_path(artist)

      expect(page).to have_selector "div.albums-header small", text: "(2 Albums)"
      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end
  end
end
