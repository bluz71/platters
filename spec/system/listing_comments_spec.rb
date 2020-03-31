require "rails_helper"

RSpec.describe "Listing comments", type: :system do
  let(:artist) { FactoryBot.create(:artist) }
  let(:release_date) { FactoryBot.create(:release_date, year: 2000) }
  let(:album) do
    FactoryBot.create(:album, artist: artist, release_date: release_date)
  end

  before do
    3.times do
      FactoryBot.create(:comment_for_album, commentable: album, body: "Comment")
    end
  end

  context "by navigating" do
    it "from artist show page to album comment section" do
      visit artist_path(artist)
      page.find(".artist-album-comments").click
      comments = page.all(".comment")
      expect(page).to have_current_path artist_album_path(artist, album)
      expect(comments.size).to eq 3
    end

    it "from albums index page to album comment section" do
      visit albums_path
      page.find(".artist-album-comments").click
      comments = page.all(".comment")
      expect(page).to have_current_path artist_album_path(artist, album)
      expect(comments.size).to eq 3
    end
  end
end
