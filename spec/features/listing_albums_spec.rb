require "rails_helper"

RSpec.feature "Listing albums" do
  let(:genre)         { FactoryGirl.create(:genre, name: "Rock") }
  let(:artist)        { FactoryGirl.create(:artist, name: "ABC") }
  let(:artist2)       { FactoryGirl.create(:artist, name: "CBA") }
  let(:release_date)  { FactoryGirl.create(:release_date, year: 2000) }
  let(:release_date2) { FactoryGirl.create(:release_date, year: 2010) }
  let!(:album) do
    FactoryGirl.create(:album, title: "ABC",
                       artist: artist, genre: genre,
                       release_date: release_date)
  end

  before do
    25.times do
      FactoryGirl.create(:album, artist: artist2, release_date: release_date2)
    end
    FactoryGirl.create(:album, title: "XYZ",
                       artist: artist, genre: genre,
                       release_date: release_date)
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

  context "by genre" do
    scenario "from album index page" do
      visit albums_path
      click_on "Rock"

      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end

    scenario "from album show page" do
      visit artist_album_path(artist, album)
      click_on "Rock"

      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end
    
    scenario "from artist show page" do
      visit artist_path(artist)
      within first(".album") do
        click_on "Rock"
      end

      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end
  end

  context "by release date" do
    scenario "from album index page" do
      visit albums_path
      within first(".album") do
        click_on "2000"
      end

      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end

    scenario "from album show page" do
      visit artist_album_path(artist, album)
      click_on "2000"


      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end

    scenario "from artist show page" do
      visit artist_path(artist)
      within first(".album") do
        click_on "2000"
      end

      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end
  end

  context "by randomization" do
    it "shuffles albums"
  end

  context "by search" do
    it "with matches"
    it "ranks title matches higher than track matches"
    it "with no matches"
  end

  context "by letter" do
    it "with matches"
    it "with no matches"
  end
end
