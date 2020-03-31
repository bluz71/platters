require "rails_helper"

RSpec.describe "Filtering albums", type: :system do
  before do
    genre1 = FactoryBot.create(:genre, name: "Rock")
    genre2 = FactoryBot.create(:genre, name: "Pop")
    artist1 = FactoryBot.create(:artist, name: "ABC")
    artist2 = FactoryBot.create(:artist, name: "XYZ")
    FactoryBot.create(
      :album, title: "First", artist: artist1, genre: genre1,
              release_date: FactoryBot.create(:release_date, year: 2000)
    )
    FactoryBot.create(
      :album, title: "Second", artist: artist1, genre: genre1,
              release_date: FactoryBot.create(:release_date, year: 2005)
    )
    FactoryBot.create(
      :album, title: "Third", artist: artist2, genre: genre2,
              release_date: FactoryBot.create(:release_date, year: 2010)
    )

    visit albums_path(filter: "true")
  end

  context "by genre" do
    it "with default title sorting", js: true do
      select "Rock", from: "Genre"
      click_on "Select"
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content "First"
      expect(albums[1]).to have_content "Second"
      expect(page).to have_current_path(albums_path(genre: "Rock"))
      # debug: URI.parse(current_url).request_uri
    end

    it "with reversed title sorting", js: true do
      select "Rock", from: "Genre"
      choose "Reverse"
      click_on "Select"
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content "Second"
      expect(albums[1]).to have_content "First"
      expect(page).to have_current_path(albums_path(genre: "Rock", order: "reverse"))
    end

    it "with year sorting", js: true do
      select "Rock", from: "Genre"
      choose "Year"
      click_on "Select"
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content "First"
      expect(albums[1]).to have_content "Second"
      expect(page).to have_current_path albums_path(genre: "Rock", sort: "year")
    end

    it "with year sorting reversed", js: true do
      select "Rock", from: "Genre"
      choose "Year"
      choose "Reverse"
      click_on "Select"
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content "Second"
      expect(albums[1]).to have_content "First"
      expect(page).to have_current_path("/albums?genre=Rock&sort=year&order=reverse")
    end
  end

  context "by year" do
    it "with default title sorting", js: true do
      fill_in "year", with: "2000, 2005"
      click_on "Select"
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content "First"
      expect(albums[1]).to have_content "Second"
      expect(page).to have_current_path(albums_path(year: "2000, 2005"))
    end

    it "with reversed title sorting", js: true do
      fill_in "year", with: "2000, 2005"
      choose "Reverse"
      click_on "Select"
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content "Second"
      expect(albums[1]).to have_content "First"
      expect(page).to have_current_path("/albums?year=2000%2C+2005&order=reverse")
    end

    it "with range", js: true do
      fill_in "year", with: "2000..2010"
      click_on "Select"
      albums = page.all(".album")
      expect(albums.size).to eq 3
      expect(albums[0]).to have_content "First"
      expect(albums[1]).to have_content "Second"
      expect(albums[2]).to have_content "Third"
      expect(page).to have_current_path(albums_path(year: "2000..2010"))
    end

    it "with genre", js: true do
      fill_in "year", with: "2000, 2005"
      select "Rock", from: "Genre"
      click_on "Select"
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content "First"
      expect(albums[1]).to have_content "Second"
      expect(page).to have_current_path(albums_path(genre: "Rock", year: "2000, 2005"))
    end

    it "with genre reversed", js: true do
      fill_in "year", with: "2000, 2005"
      select "Rock", from: "Genre"
      choose "Reverse"
      click_on "Select"
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content "Second"
      expect(albums[1]).to have_content "First"
      expected_path = "/albums?genre=Rock&year=2000%2C+2005&order=reverse"
      expect(page).to have_current_path(expected_path)
    end
  end
end
