require "rails_helper"

RSpec.describe "Editing albums", type: :system do
  let!(:genre)        { FactoryBot.create(:genre, name: "Rock") }
  let!(:artist)       { FactoryBot.create(:artist, name: "ABC") }
  let!(:release_date) { FactoryBot.create(:release_date) }
  let!(:album) do
    FactoryBot.create(:album,
                      title: "Album", artist: artist, release_date: release_date)
  end
  let(:admin) { FactoryBot.create(:admin) }

  context "access" do
    it "is disallowed for anonymous users" do
      visit edit_artist_album_path(artist, album)
      expect(page).to have_content "Administrator rights are required for this action"
    end

    it "is disallowed for non-administrator users" do
      user = FactoryBot.create(:user)
      visit edit_artist_album_path(artist, album, as: user.id)
      expect(page).to have_content "Administrator rights are required for this action"
    end
  end

  context "from album page with updated" do
    before do
      visit artist_album_path(artist, album, as: admin.id)
      click_on "Edit"
    end

    after do
      # Cleanup Carrierwave uploads.
      FileUtils.rm_rf(Rails.root.join("spec", "uploads"))
    end

    it "title" do
      fill_in "Title", with: "XYZ"
      click_on "Submit"

      album.reload
      expect(current_path).to eq artist_album_path(artist, album)
      expect(page).to have_content "XYZ has been updated"
      expect(page).to have_title "XYZ"
      expect(page).to have_selector "div#album h1", text: "XYZ"
    end

    it "genre" do
      select "Rock", from: "Genre"
      click_on "Submit"

      expect(page).to have_content "Rock"
    end

    it "year" do
      fill_in "Year", with: "2010"
      click_on "Submit"

      expect(page).to have_content "2010"
    end

    it "track list" do
      fill_in "Track list", with: "First track (2:12)"
      click_on "Submit"

      expect(page).to have_selector "div#album td", text: "1."
      expect(page).to have_selector "div#album td", text: "First track"
      expect(page).to have_selector "div#album td", text: "2:12"
    end

    it "cover" do
      attach_file "Cover", Rails.root.join("spec", "fixtures", "cover.jpg")
      click_on "Submit"

      album.reload
      expect(album.cover.url).to match(%r{/uploads/album/cover/[\d]+/cover.jpg})
      expect(page).to have_css "div#album img[src='#{album.cover.url}']"
    end
  end

  context "from artist page with updated" do
    before do
      visit artist_path(artist, as: admin.id)

      # Click on the 2nd Edit link, first is Edit Artist, 2nd is Edit Album.
      within ".album" do
        click_on "Edit"
      end
    end

    after do
      # Cleanup Carrierwave uploads.
      FileUtils.rm_rf(Rails.root.join("spec", "uploads"))
    end

    it "title" do
      fill_in "Title", with: "XYZ"
      click_on "Submit"

      album.reload
      expect(current_path).to eq artist_album_path(artist, album)
      expect(page).to have_content "XYZ has been updated"
      expect(page).to have_title "XYZ"
      expect(page).to have_selector "div#album h1", text: "XYZ"
    end
  end

  context "will fail" do
    before do
      visit artist_album_path(artist, album, as: admin.id)
      click_on "Edit"
    end

    it "with blank title" do
      fill_in "Title", with: ""
      click_on "Submit"

      expect(page).to have_content "Album could not be updated"
      expect(page).to have_content "Title can't be blank"
    end

    it "when year greater than current year" do
      fill_in "Year", with: (Date.current.year + 1).to_s
      click_on "Submit"

      expect(page).to have_content "Album could not be updated"
    end

    it "when track listing is invalid" do
      fill_in "Track list", with: "First track"
      click_on "Submit"

      expect(page).to have_content "Album could not be updated"
    end
  end

  context "when cancelled from album page" do
    before do
      visit artist_album_path(artist, album, as: admin.id)
      click_on "Edit"
    end

    it "goes back" do
      expect(current_path).to eq edit_artist_album_path(artist, album)
      click_on "Cancel"
      expect(current_path).to eq artist_album_path(artist, album)
    end

    it "goes back after validation error" do
      fill_in "Title", with: ""
      click_on "Submit"
      click_on "Cancel"
      expect(current_path).to eq artist_path(artist)
    end
  end

  context "when cancelled from artist page" do
    before do
      visit artist_path(artist, as: admin.id)

      # Click on the 2nd Edit link, first is Edit Artist, 2nd is Edit Album.
      within ".album" do
        click_on "Edit"
      end
    end

    it "goes back" do
      expect(current_path).to eq edit_artist_album_path(artist, album)
      click_on "Cancel"
      expect(current_path).to eq artist_path(artist)
    end

    it "goes back after validation error" do
      fill_in "Title", with: ""
      click_on "Submit"
      click_on "Cancel"
      expect(current_path).to eq artist_path(artist)
    end
  end
end
