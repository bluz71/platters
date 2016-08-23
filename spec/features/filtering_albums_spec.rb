require "rails_helper"

RSpec.feature "Filtering albums" do
  let(:genre1)        { FactoryGirl.create(:genre, name: "Rock") }
  let(:genre2)        { FactoryGirl.create(:genre, name: "Pop") }
  let(:artist1)       { FactoryGirl.create(:artist, name: "ABC") }
  let(:artist2)       { FactoryGirl.create(:artist, name: "XYZ") }
  let(:release_date1) { FactoryGirl.create(:release_date, year: 2000) }
  let(:release_date2) { FactoryGirl.create(:release_date, year: 2005) }
  let(:release_date3) { FactoryGirl.create(:release_date, year: 2010) }
  let!(:album1) do
    FactoryGirl.create(:album, title: "First", artist: artist1, genre: genre1,
                       release_date: release_date1)
  end
  let!(:album2) do
    FactoryGirl.create(:album, title: "Second", artist: artist1, genre: genre1,
                       release_date: release_date2)
  end
  let!(:album3) do
    FactoryGirl.create(:album, title: "Third", artist: artist2, genre: genre2,
                       release_date: release_date3)
  end

  before do
    visit albums_path
    page.find(".filter-link").click
    wait_for_js
  end

  context "by genre" do
    scenario "with default title sorting", js: true do
      select "Rock", from: "Genre" 
      click_on "Select"
      # Sometimes expected GET parameters go missing from this JS test, hence
      # must go visit filter URL directly.
      visit albums_path(genre: "Rock") if URI.parse(current_url).request_uri != albums_path(genre: "Rock")
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("First")
      expect(albums[1]).to have_content("Second")
    end

    scenario "with reversed title sorting", js: true do
      select "Rock", from: "Genre" 
      choose "Reverse"
      click_on "Select"
      # Sometimes expected GET parameters go missing from this JS test, hence
      # must go visit filter URL directly.
      visit albums_path(genre: "Rock", order: "reverse") if URI.parse(current_url).request_uri != albums_path(genre: "Rock", order: "reverse")
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("Second")
      expect(albums[1]).to have_content("First")
    end

    scenario "with year sorting", js: true do
      select "Rock", from: "Genre" 
      choose "Year"
      click_on "Select"
      # Sometimes expected GET parameters go missing from this JS test, hence
      # must go visit filter URL directly.
      visit albums_path(genre: "Rock", sort: "year") if URI.parse(current_url).request_uri != albums_path(genre: "Rock", sort: "year")
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("First")
      expect(albums[1]).to have_content("Second")
    end

    scenario "with year sorting reversed", js: true do
      select "Rock", from: "Genre" 
      choose "Year"
      choose "Reverse"
      click_on "Select"
      # Sometimes expected GET parameters go missing from this JS test, hence
      # must go visit filter URL directly.
      visit "/albums?genre=Rock&sort=year&order=reverse" if URI.parse(current_url).request_uri != "/albums?genre=Rock&sort=year&order=reverse"
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("Second")
      expect(albums[1]).to have_content("First")
    end
  end

  context "by year" do
    scenario "with default title sorting", js: true do
      fill_in "year", with: "2000, 2005"
      click_on "Select"
      # Sometimes expected GET parameters go missing from this JS test, hence
      # must go visit filter URL directly.
      visit albums_path(year: "2000, 2005") if URI.parse(current_url).request_uri != albums_path(year: "2000, 2005")
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("First")
      expect(albums[1]).to have_content("Second")
    end

    scenario "with reversed title sorting", js: true do
      fill_in "year", with: "2000, 2005"
      choose "Reverse"
      click_on "Select"
      # Sometimes expected GET parameters go missing from this JS test, hence
      # must go visit filter URL directly.
      visit "/albums?year=2000%2C+2005&order=reverse" if URI.parse(current_url).request_uri != "/albums?year=2000%2C+2005&order=reverse"
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("Second")
      expect(albums[1]).to have_content("First")
    end

    scenario "with range", js: true do
      fill_in "year", with: "2000..2010"
      click_on "Select"
      # Sometimes expected GET parameters go missing from this JS test, hence
      # must go visit filter URL directly.
      visit albums_path(year: "2000..2010") if URI.parse(current_url).request_uri != albums_path(year: "2000..2010")
      albums = page.all(".album")
      expect(albums.size).to eq 3
      expect(albums[0]).to have_content("First")
      expect(albums[1]).to have_content("Second")
      expect(albums[2]).to have_content("Third")
    end

    scenario "with genre", js: true do
      fill_in "year", with: "2000, 2005"
      select "Rock", from: "Genre" 
      click_on "Select"
      # Sometimes expected GET parameters go missing from this JS test, hence
      # must go visit filter URL directly.
      visit albums_path(genre: "Rock", year: "2000, 2005") if URI.parse(current_url).request_uri != albums_path(genre: "Rock", year: "2000, 2005")
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("First")
      expect(albums[1]).to have_content("Second")
    end

    scenario "with genre reversed", js: true do
      fill_in "year", with: "2000, 2005"
      select "Rock", from: "Genre" 
      choose "Reverse"
      click_on "Select"
      # Sometimes expected GET parameters go missing from this JS test, hence
      # must go visit filter URL directly.
      visit "/albums?genre=Rock&year=2000%2C+2005&order=reverse" if URI.parse(current_url).request_uri != "/albums?genre=Rock&year=2000%2C+2005&order=reverse"
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("Second")
      expect(albums[1]).to have_content("First")
    end
  end
end
