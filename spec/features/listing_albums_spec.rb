require "rails_helper"

RSpec.feature "Listing albums" do
  let(:genre)         { FactoryGirl.create(:genre, name: "Rock") }
  let(:artist)        { FactoryGirl.create(:artist, name: "ABC") }
  let(:artist2)       { FactoryGirl.create(:artist, name: "CBA") }
  let(:release_date)  { FactoryGirl.create(:release_date, year: 2000) }
  let(:release_date2) { FactoryGirl.create(:release_date, year: 2010) }
  let!(:album1) do
    FactoryGirl.create(:album, title: "ABC",
                       artist: artist, genre: genre,
                       release_date: release_date)
  end
  let!(:album2) do
    FactoryGirl.create(:album, title: "XYZ",
                       artist: artist, genre: genre,
                       release_date: release_date)
  end

  before do
    25.times do
      FactoryGirl.create(:album, artist: artist2, release_date: release_date2)
    end
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

      expect(page).to have_selector "div.page-header small", text: "(2 Albums)"
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
      visit artist_album_path(artist, album1)
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
      visit artist_album_path(artist, album1)
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
    it "shuffles albums" do
      visit albums_path
      page.find(".random-link").click
      first_album = page.all(".album")[0]
      first_random_album_is_different = false;
      10.times do
        page.find(".random-link").click
        if page.all(".album")[0] != first_album
          first_random_album_is_different = true
          break
        end
      end
      expect(first_random_album_is_different).to be_truthy
      expect(page).to have_content("20 Albums")
    end
  end

  context "by search" do
    before do
      visit albums_path
    end

    it "with matches", js: true do
      page.find(".search-link").click
      wait_for_js
      fill_in "search", with: "ABC"
      page.find(".search-submit").click
      albums = page.all(".album")
      expect(albums.size).to eq 1
      expect(albums[0]).to have_content "ABC"
    end

    it "ranks title matches higher than track matches", js: true do
      FactoryGirl.create(:track, title: "ABC", album: album2)
      page.find(".search-link").click
      wait_for_js
      fill_in "search", with: "ABC"
      page.find(".search-submit").click
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content "ABC"
      expect(albums[1]).to have_content "XYZ"
    end

    it "with no matches", js: true do
      page.find(".search-link").click
      wait_for_js
      fill_in "search", with: "foobar"
      page.find(".search-submit").click
      albums = page.all(".album")
      expect(albums.size).to eq 0
    end
  end

  context "by letter" do
    before do
      visit albums_path
    end

    it "with matches" do
      click_on "X"

      albums = page.all(".album")
      expect(albums.size).to eq 1
      expect(albums[0]).to have_content "XYZ"
    end

    it "with no matches" do
      click_on "B"

      albums = page.all(".album")
      expect(albums.size).to eq 0
    end
  end
end
