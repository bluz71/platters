require "rails_helper"

RSpec.feature "Editing albums" do
  let!(:genre)       { FactoryGirl.create(:genre, name: "Rock") }
  let(:artist)       { FactoryGirl.create(:artist, name: "ABC") }
  let(:release_date) { FactoryGirl.create(:release_date) }
  let(:album) do 
    FactoryGirl.create(:album, title: "Album",
                       artist: artist, release_date: release_date)
  end

  context "from artist page with updated" do
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

      expect(page).to have_css "div#album img[src='/uploads/album/cover/1/cover.jpg']"
    end
  end

  context "from album page with updated" do
    scenario "title"
  end

  context "will fail" do
    scenario "with blank title"
    scenario "when year greater than current year"
    scenario "when track listing is invalid"
  end

  context "when cancelled from artist page" do
    scenario "goes back"
    scenario "goes back after validation error"
  end

  context "when cancelled from album page" do
    scenario "goes back"
    scenario "goes back after validation error"
  end
end
