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

  context "by genre" do
    scenario "with default title sorting", js: true do
      # Sometimes expected GET parameters mysteriously go missing from this JS
      # test, hence try a few times.
      5.times do
        visit albums_path
        page.find(".filter-link").click
        wait_for_js
        select "Rock", from: "Genre" 
        click_on "Select"
        wait_for_js
        break if URI.parse(current_url).request_uri == albums_path(genre: "Rock")
      end
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("First")
      expect(albums[1]).to have_content("Second")
      expect(page).to have_current_path(albums_path(genre: "Rock"))
    end

    scenario "with reversed title sorting", js: true do
      # Sometimes expected GET parameters mysteriously go missing from this JS
      # test, hence try a few times.
      5.times do
        visit albums_path
        page.find(".filter-link").click
        wait_for_js
        select "Rock", from: "Genre" 
        choose "Reverse"
        click_on "Select"
        wait_for_js
        break if URI.parse(current_url).request_uri == albums_path(genre: "Rock", order: "reverse")
      end
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("Second")
      expect(albums[1]).to have_content("First")
      expect(page).to have_current_path(albums_path(genre: "Rock", order: "reverse"))
    end

    scenario "with year sorting", js: true do
      # Sometimes expected GET parameters mysteriously go missing from this JS
      # test, hence try a few times.
      5.times do
        visit albums_path
        page.find(".filter-link").click
        wait_for_js
        select "Rock", from: "Genre" 
        choose "Year"
        click_on "Select"
        wait_for_js
        break if URI.parse(current_url).request_uri == albums_path(genre: "Rock", sort: "year")
      end
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("First")
      expect(albums[1]).to have_content("Second")
      expect(page).to have_current_path(albums_path(genre: "Rock", sort: "year"))
    end

    scenario "with year sorting reversed", js: true do
      # Sometimes expected GET parameters mysteriously go missing from this JS
      # test, hence try a few times.
      5.times do
        visit albums_path
        page.find(".filter-link").click
        wait_for_js
        select "Rock", from: "Genre" 
        choose "Year"
        choose "Reverse"
        click_on "Select"
        wait_for_js
        break if URI.parse(current_url).request_uri == "/albums?genre=Rock&sort=year&order=reverse"
      end
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("Second")
      expect(albums[1]).to have_content("First")
      expect(page).to have_current_path("/albums?genre=Rock&sort=year&order=reverse")
    end
  end

  context "by year" do
    scenario "with default title sorting", js: true do
      # Sometimes expected GET parameters mysteriously go missing from this JS
      # test, hence try a few times.
      5.times do
        visit albums_path
        page.find(".filter-link").click
        wait_for_js
        fill_in "year", with: "2000, 2005"
        click_on "Select"
        wait_for_js
        break if  URI.parse(current_url).request_uri == albums_path(year: "2000, 2005")
      end
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("First")
      expect(albums[1]).to have_content("Second")
      expect(page).to have_current_path(albums_path(year: "2000, 2005"))
    end

    scenario "with reversed title sorting", js: true do
      # Sometimes expected GET parameters mysteriously go missing from this JS
      # test, hence try a few times.
      5.times do
        visit albums_path
        page.find(".filter-link").click
        wait_for_js
        fill_in "year", with: "2000, 2005"
        choose "Reverse"
        click_on "Select"
        wait_for_js
        break if URI.parse(current_url).request_uri == "/albums?year=2000%2C+2005&order=reverse"
      end
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("Second")
      expect(albums[1]).to have_content("First")
      expect(page).to have_current_path("/albums?year=2000%2C+2005&order=reverse")
    end

    scenario "with range", js: true do
      # Sometimes expected GET parameters mysteriously go missing from this JS
      # test, hence try a few times.
      5.times do
        visit albums_path
        page.find(".filter-link").click
        wait_for_js
        fill_in "year", with: "2000..2010"
        click_on "Select"
        wait_for_js
        break if URI.parse(current_url).request_uri == albums_path(year: "2000..2010")
      end
      albums = page.all(".album")
      expect(albums.size).to eq 3
      expect(albums[0]).to have_content("First")
      expect(albums[1]).to have_content("Second")
      expect(albums[2]).to have_content("Third")
      expect(page).to have_current_path(albums_path(year: "2000..2010"))
    end

    scenario "with genre", js: true do
      # Sometimes expected GET parameters mysteriously go missing from this JS
      # test, hence try a few times.
      15.times do
        visit albums_path
        page.find(".filter-link").click
        wait_for_js
        fill_in "year", with: "2000, 2005"
        select "Rock", from: "Genre" 
        click_on "Select"
        wait_for_js
        break if URI.parse(current_url).request_uri == albums_path(genre: "Rock", year: "2000, 2005")
      end
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("First")
      expect(albums[1]).to have_content("Second")
      expect(page).to have_current_path(albums_path(genre: "Rock", year: "2000, 2005"))
    end

    scenario "with genre reversed", js: true do
      # Sometimes expected GET parameters mysteriously go missing from this JS
      # test, hence try a few times.
      15.times do
        visit albums_path
        page.find(".filter-link").click
        wait_for_js
        fill_in "year", with: "2000, 2005"
        select "Rock", from: "Genre" 
        choose "Reverse"
        click_on "Select"
        wait_for_js
        break if URI.parse(current_url).request_uri == "/albums?genre=Rock&year=2000%2C+2005&order=reverse"
      end
      albums = page.all(".album")
      expect(albums.size).to eq 2
      expect(albums[0]).to have_content("Second")
      expect(albums[1]).to have_content("First")
      expect(page).to have_current_path("/albums?genre=Rock&year=2000%2C+2005&order=reverse")
    end
  end
end
