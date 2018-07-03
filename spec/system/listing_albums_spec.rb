require "rails_helper"

RSpec.describe "Listing albums", type: :system do
  let(:genre)         { FactoryBot.create(:genre, name: "Rock") }
  let(:artist)        { FactoryBot.create(:artist, name: "ABC") }
  let(:artist2)       { FactoryBot.create(:artist, name: "CBA") }
  let(:release_date)  { FactoryBot.create(:release_date, year: 2000) }
  let(:release_date2) { FactoryBot.create(:release_date, year: 2010) }
  let!(:album1) do
    FactoryBot.create(:album, title: "ABC",
                      artist: artist, genre: genre,
                      release_date: release_date)
  end
  let!(:album2) do
    FactoryBot.create(:album, title: "XYZ",
                      artist: artist, genre: genre,
                      release_date: release_date)
  end

  before do
    25.times do
      FactoryBot.create(:album, artist: artist2, release_date: release_date2)
    end
  end

  context "for all artists" do
    it "will be alpabetized" do
      visit albums_path

      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).not_to have_selector "div.album h2", text: "XYZ"
    end

    it "will successfully paginate" do
      visit albums_path
      click_on "Next"

      expect(page).not_to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end
  end

  context "for a certain artist" do
    it "will display only their albums" do
      visit artist_path(artist)

      expect(page).to have_selector "div.page-header small", text: "(2 Albums)"
      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end
  end

  context "by genre" do
    it "from album index page" do
      visit albums_path
      click_on "Rock"

      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end

    it "from album show page" do
      visit artist_album_path(artist, album1)
      click_on "Rock"

      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end

    it "from artist show page" do
      visit artist_path(artist)
      within first(".album") do
        click_on "Rock"
      end

      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end
  end

  context "by release date" do
    it "from album index page" do
      visit albums_path
      within first(".album") do
        click_on "2000"
      end

      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end

    it "from album show page" do
      visit artist_album_path(artist, album1)
      click_on "2000"

      expect(page).to have_selector "div.album h2", text: "ABC"
      expect(page).to have_selector "div.album h2", text: "XYZ"
    end

    it "from artist show page" do
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
      first_random_album_is_different = false
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
      albums = nil
      # Run this test multiple times since PhantomJS does not always appear
      # to correctly fill_in the search field.
      5.times do
        page.find(".search-link").click
        fill_in "search", with: "ABC"
        page.find(".search-submit").click
        albums = page.all(".album")
        break if albums.size == 1
      end
      expect(albums.size).to eq 1
      expect(albums[0]).to have_content "ABC"
    end

    it "ranks title matches higher than track matches", js: true do
      FactoryBot.create(:track, title: "ABC", album: album2)
      albums = nil
      # Run this test multiple times since PhantomJS does not always appear
      # to correctly fill_in the search field.
      5.times do
        page.find(".search-link").click
        fill_in "search", with: "ABC"
        page.find(".search-submit").click
        albums = page.all(".album")
        break if albums.size == 2
      end
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content "ABC"
      expect(albums[1]).to have_content "XYZ"
    end

    it "with no matches", js: true do
      albums = nil
      # Run this test multiple times since PhantomJS does not always appear
      # to correctly fill_in the search field.
      5.times do
        page.find(".search-link").click
        fill_in "search", with: "foobar"
        page.find(".search-submit").click
        albums = page.all(".album")
        break if albums.empty?
      end
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
