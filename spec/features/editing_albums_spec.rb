require "rails_helper"

RSpec.feature "Editing albums" do
  let!(:genre)       { FactoryGirl.create(:genre, name: "Rock") }
  let!(:artist)       { FactoryGirl.create(:artist, name: "ABC") }
  let!(:release_date) { FactoryGirl.create(:release_date) }
  let!(:album) do 
    FactoryGirl.create(:album, title: "Album",
                       artist: artist, release_date: release_date)
  end

  context "from album page with updated" do
    before do
      visit artist_album_path(artist, album)
      click_on "Edit"
    end

    after do
      # Cleanup Carrierwave uploads.
      FileUtils.rm_rf(Rails.root.join("spec", "uploads"))
    end

    scenario "title" do
      fill_in "Title", with: "XYZ"
      click_on "Submit"

      expect(current_path).to eq artist_album_path(artist, album)
      expect(page).to have_content "XYZ has been updated"
      expect(page).to have_title "XYZ"
      expect(page).to have_selector "div#album h1", text: "XYZ"
    end

    scenario "genre" do
      select "Rock", from: "Genre"
      click_on "Submit"

      expect(page).to have_content "Rock"
    end

    scenario "year" do
      fill_in "Year", with: "2010"
      click_on "Submit"

      expect(page).to have_content "2010"
    end

    scenario "track list" do
      fill_in "Track list", with: "First track (2:12)"
      click_on "Submit"

      expect(page).to have_selector "div#album td", text: "1."
      expect(page).to have_selector "div#album td", text: "First track"
      expect(page).to have_selector "div#album td", text: "2:12"
    end

    scenario "cover" do
      attach_file "Cover", Rails.root.join("spec", "fixtures", "cover.jpg")
      click_on "Submit"

      album.reload
      expect(album.cover.url).to eq "/uploads/album/cover/1/cover.jpg"
      expect(page).to have_css "div#album img[src='#{album.cover.url}']"
    end
  end

  context "from artist page with updated" do
    before do
      visit artist_path(artist)

      # Click on the 2nd Edit link, first is Edit Artist, 2nd is Edit Album.
      within ".album" do
        click_on "Edit"
      end
    end

    after do
      # Cleanup Carrierwave uploads.
      FileUtils.rm_rf(Rails.root.join("spec", "uploads"))
    end

    scenario "title" do
      fill_in "Title", with: "XYZ"
      click_on "Submit"

      expect(current_path).to eq artist_album_path(artist, album)
      expect(page).to have_content "XYZ has been updated"
      expect(page).to have_title "XYZ"
      expect(page).to have_selector "div#album h1", text: "XYZ"
    end
  end

  context "will fail" do
    before do
      visit artist_album_path(artist, album)
      click_on "Edit"
    end

    scenario "with blank title" do
      fill_in "Title", with: ""
      click_on "Submit"

      expect(page).to have_content "Album could not be updated"
      expect(page).to have_content "Title can't be blank"
    end

    scenario "when year greater than current year" do
      fill_in "Year", with: (Date.current.year + 1).to_s
      click_on "Submit"

      expect(page).to have_content "Album could not be updated"
    end

    scenario "when track listing is invalid" do
      fill_in "Track list", with: "First track"
      click_on "Submit"

      expect(page).to have_content "Album could not be updated"
    end
  end

  context "when cancelled from album page" do
    before do
      visit artist_album_path(artist, album)
      click_on "Edit"
    end

    scenario "goes back" do
      expect(current_path).to eq edit_artist_album_path(artist, album)
      click_on "Cancel"
      expect(current_path).to eq artist_album_path(artist, album)
    end

    scenario "goes back after validation error" do
      fill_in "Title", with: ""
      click_on "Submit"
      click_on "Cancel"
      expect(current_path).to eq artist_path(artist)
    end
  end

  context "when cancelled from artist page" do
    before do
      visit artist_path(artist)

      # Click on the 2nd Edit link, first is Edit Artist, 2nd is Edit Album.
      within ".album" do
        click_on "Edit"
      end
    end

    scenario "goes back" do
      expect(current_path).to eq edit_artist_album_path(artist, album)
      click_on "Cancel"
      expect(current_path).to eq artist_path(artist)
    end

    scenario "goes back after validation error" do
      fill_in "Title", with: ""
      click_on "Submit"
      click_on "Cancel"
      expect(current_path).to eq artist_path(artist)
    end
  end
end
