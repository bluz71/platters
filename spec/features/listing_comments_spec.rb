require "rails_helper"

RSpec.feature "Listing comments" do
  let(:artist)       { FactoryGirl.create(:artist) }
  let(:release_date) { FactoryGirl.create(:release_date, year: 2000) }
  let(:album) do
    FactoryGirl.create(:album, artist: artist, release_date: release_date)
  end

  before do
    3.times do
      FactoryGirl.create(:comment_for_album, commentable: album, body: "Comment")
    end
  end

  context "by navigating" do
    scenario "from artist show page to album comment section" do
      visit artist_path(artist)
      page.find(".artist-album-comments").click
      comments = page.all(".comment")
      expect(page).to have_current_path artist_album_path(artist, album)
      expect(comments.size).to eq 3
    end

    scenario "from albums index page to album comment section" do
      visit albums_path
      page.find(".artist-album-comments").click
      comments = page.all(".comment")
      expect(page).to have_current_path artist_album_path(artist, album)
      expect(comments.size).to eq 3
    end
  end
end
