require "rails_helper"

RSpec.describe "Showing albums", type: :system do
  let(:genre) { FactoryBot.create(:genre, name: "Rock") }
  let(:artist) { FactoryBot.create(:artist, name: "ABC") }
  let(:release_date) { FactoryBot.create(:release_date, year: 2013) }

  context "details" do
    let(:album) do
      FactoryBot.create(
        :album_with_tracks, title: "XYZ", artist: artist, genre: genre,
                            release_date: release_date
      )
    end

    it "will include track count, release date year and genre" do
      visit artist_album_path(artist, album)

      expect(page).to have_content "XYZ by ABC"
      expect(page).to have_content "3 Tracks (Time 9:24)"
      expect(page).to have_content "2013"
      expect(page).to have_content "Rock"
    end
  end

  context "tracks will" do
    let(:album) do
      FactoryBot.create(
        :album_with_tracks, title: "XYZ", artist: artist, genre: genre,
                            release_date: release_date
      )
    end

    before do
      FactoryBot.create(:track, title: "Start", album: album)
      25.times do
        FactoryBot.create(:track, album: album)
      end
      FactoryBot.create(:track, title: "End", album: album)
    end

    it "display only the first twenty tracks by default" do
      visit artist_album_path(artist, album)

      expect(page).to have_selector "tr.invisible td", text: "End"
    end

    it "display all tracks when 'show all tracks' is selected", js: true do
      visit artist_album_path(artist, album)
      click_on "Show all tracks"

      expect(page).to have_selector "tr.visible td", text: "Start"
      expect(page).to have_selector "tr.visible td", text: "End"
    end

    it "display the first twenty tracks when 'show less tracks' is "\
             "selected", js: true do
      visit artist_album_path(artist, album)
      click_on "Show all tracks"
      click_on "Show less tracks"

      expect(page).not_to have_selector "tr.visible td", text: "End"
    end
  end

  it "will display an error message for an invalid album path" do
    visit artist_album_path("foo", "bar")

    expect(current_path).to eq albums_path
    expect(page).to have_content "The album 'bar' does not exist"
  end
end
