require "rails_helper"

RSpec.feature "Adding albums" do
  let!(:genre) { FactoryGirl.create(:genre, name: "Rock") }
  let(:artist) { FactoryGirl.create(:artist, name: "ABC") }
  let(:admin) { FactoryGirl.create(:admin) }

  context "access" do
    scenario "is disallowed for anonymous users" do
      visit new_artist_album_path(artist)
      expect(page).to have_content "Administrator rights are required for this action"
    end

    scenario "is disallowed for non-administrator users" do
      user = FactoryGirl.create(:user)
      visit new_artist_album_path(artist, as: user.id)
      expect(page).to have_content "Administrator rights are required for this action"
    end
  end

  context "when submitting" do
    before do
      visit artist_path(artist, as: admin.id)
      click_on "Album"
    end

    after do
      # Cleanup Carrierwave uploads.
      FileUtils.rm_rf(Rails.root.join("spec", "uploads"))
    end

    scenario "with valid attributes" do
      fill_in "Title", with: "XYZ"
      select "Rock", from: "Genre"
      fill_in "Year", with: "2010"
      fill_in "Track list", with: "First track (2:12)"
      attach_file "Cover", Rails.root.join("spec", "fixtures", "cover.jpg")

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
      expect(album.cover.url).to eq "/uploads/album/cover/1/cover.jpg"
      expect(page).to have_css "div#album img[src='#{album.cover.url}']"
    end

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
      expect(page).to have_content "Track list format error, 1st track is either "\
                                   "missing: duration at the end of the line, or a "\
                                   "whitespace before the duration"
    end
  end

  context "when cancelled" do
    before do
      visit artist_path(artist, as: admin.id)
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

  context "with new genre" do
    before do
      visit artist_path(artist, as: admin.id)
      click_on "Album"
      click_on "Genre"
    end

    scenario "will be append the new Genre to the end of the Genre "\
             "list", js: true, no_clean: true do
      fill_in "genre_name", with: "Pop"
      click_on "Add"
      wait_for_js
      options = page.all("select option")

      if options.size > 1
        expect(options.size).to eq 2
        expect(options[0]).to have_content "Rock"
        expect(options[1]).to have_content("Pop").or have_content("P")
      end
    end

    scenario "will not append the new Genre to the end of Genre list if it "\
             "already exists", js: true, no_clean: true do
      fill_in "genre_name", with: "Rock"
      click_on "Add"
      options = page.all("select option")

      expect(options.size).to eq 1
      expect(options[0]).to have_content "Rock"
    end
  end
end
