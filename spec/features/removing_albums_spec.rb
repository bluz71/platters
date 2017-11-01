require "rails_helper"

RSpec.feature "Removing albums" do
  let!(:artist)        { FactoryBot.create(:artist, name: "ABC") }
  let!(:release_date)  { FactoryBot.create(:release_date, year: 2000) }
  let!(:album) do
    FactoryBot.create(:album, title: "Album",
                      artist: artist, release_date: release_date)
  end
  let(:admin) { FactoryBot.create(:admin) }

  context "access" do
    scenario "is disallowed for anonymous users" do
      page.driver.delete(artist_album_path(artist, album))
      expect(Album.exists?(album.id)).to be_truthy
    end

    scenario "is disallowed for non-administrator users" do
      user = FactoryBot.create(:user)
      page.driver.delete(artist_album_path(artist, album, as: user.id))
      expect(Album.exists?(album.id)).to be_truthy
    end
  end

  context "from album page" do
    scenario "successfully" do
      visit artist_album_path(artist, album, as: admin.id)
      click_on "Remove"

      expect(current_path).to eq artist_path(artist)
      expect(page).to have_content "Album has been removed"
      expect(page).not_to have_selector "div.album h2", text: "Album"
    end
  end

  context "from artist page", js: true do
    scenario "successfully with JavaScript" do
      visit artist_path(artist, as: admin.id)

      # Click on the 2nd Remove link, first is Remove Artist, 2nd is Remove Album.
      accept_alert do
        within ".album" do
          click_on "Remove"
        end
      end

      expect(current_path).to eq artist_path(artist)
      expect(page).not_to have_selector "div.album h2", text: "Album"
    end
  end
end
