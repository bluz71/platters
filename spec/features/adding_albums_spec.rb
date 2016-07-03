require "rails_helper"

RSpec.feature "Adding albums" do
  let!(:genre) { FactoryGirl.create(:genre, name: "Rock") }
  let(:artist) { FactoryGirl.create(:artist, name: "ABC") }

  context "when submitting" do
    before do
      visit artist_path(artist)
      click_on "Album"
    end

    scenario "with valid attributes" do
      fill_in "Title", with: "XYZ"
      select "Rock", from: "Genre"
      fill_in "Year", with: "2010"
      fill_in "Track list", with: "First track (2:12)"
      click_on "Submit"

      album = Album.find_by(title: "XYZ")
      expect(current_path).to eq artist_album_path(artist, album)
      expect(page).to have_content "XYZ has been created"
      expect(page).to have_title "XYZ"
      expect(page).to have_selector "div#album h1", text: "XYZ"
      expect(page).to have_content "2010"
      expect(page).to have_content "Rock"
      expect(page).to have_selector "div#album td", text: "1."
      expect(page).to have_selector "div#album td", text: "First track"
      expect(page).to have_selector "div#album td", text: "2:12"
    end

    scenario "with cover"

    scenario "with blank values" do
      click_on "Submit"

      expect(page).to have_content "Album could not be created"
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Year is not a number"
    end

    scenario "with invalid tracks" do
      fill_in "Title", with: "XYZ"
      select "Rock", from: "Genre"
      fill_in "Year", with: "2010"
      fill_in "Track list", with: "First track"
      click_on "Submit"

      expect(page).to have_content "Album could not be created"
      expect(page).to have_content "Track list format error, 1st track is either missing: " <<
                                   "duration at the end of the line, or a whitespace before the duration"
    end
  end

  context "when cancelled" do
    before do
      visit artist_path(artist)
      click_on "Album"
    end

    scenario "goes back" do
      expect(current_path).to eq new_artist_album_path(artist)

      click_on "Cancel"
      expect(current_path).to eq artist_path(artist)
    end

    scenario "goes back after validation error" do
      click_on "Submit"
      click_on "Cancel"
      expect(current_path).to eq artist_path(artist)
    end
  end
end
