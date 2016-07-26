require "rails_helper"

RSpec.feature "Showing artist albums" do
  let(:artist) { FactoryGirl.create(:artist) }

  let!(:album1) do
    FactoryGirl.create(:album_with_tracks, title: "Artist_Album-1",
                       artist: artist, year: 2005)
  end

  let!(:album2) do 
    FactoryGirl.create(:album_with_tracks, title: "Artist_Album-2",
                       artist: artist, year: 2010)
  end

  let!(:album3) do
    FactoryGirl.create(:album, title: "Artist_Album-3",
                       artist: artist, year: 2000)
  end

  let!(:album4) do
    FactoryGirl.create(:album, title: "Artist_Album-4",
                       artist: artist, year: 1995)
  end

  let!(:track1) do
    FactoryGirl.create(:track, duration: 600, album: album1)
  end

  let!(:track2) do
    FactoryGirl.create(:track, duration: 200, album: album4)
  end

  let!(:track3) do
    FactoryGirl.create(:track, duration: 100, album: album3)
  end

  let!(:track4) do
    FactoryGirl.create(:track, duration: 50, album: album2)
  end

  before do
    visit artist_path(artist)
  end

  scenario "lists artist albums in reverse chronological order by default" do
    albums = page.all(".album")
    expect(albums[0]).to have_content("Artist_Album-2")
    expect(albums[1]).to have_content("Artist_Album-1")
    expect(albums[2]).to have_content("Artist_Album-3")
    expect(albums[3]).to have_content("Artist_Album-4")
  end

  scenario "lists artist albums newest to oldest when 'newest' is selected", js:true do
    click_on "Newest"
    wait_for_js

    albums = page.all(".album")
    expect(albums[0]).to have_content("Artist_Album-2")
    expect(albums[1]).to have_content("Artist_Album-1")
    expect(albums[2]).to have_content("Artist_Album-3")
    expect(albums[3]).to have_content("Artist_Album-4")
  end

  scenario "lists artist albums oldest to newest when 'oldest' is selected", js:true do
    click_on "Oldest"
    wait_for_js

    albums = page.all(".album")
    expect(albums[0]).to have_content("Artist_Album-4")
    expect(albums[1]).to have_content("Artist_Album-3")
    expect(albums[2]).to have_content("Artist_Album-1")
    expect(albums[3]).to have_content("Artist_Album-2")
  end

  scenario "lists artist albums longest to shortest when 'longest' is selected", js:true do
    click_on "Longest"
    wait_for_js

    albums = page.all(".album")
    expect(albums[0]).to have_content("Artist_Album-1")
    expect(albums[1]).to have_content("Artist_Album-4")
    expect(albums[2]).to have_content("Artist_Album-3")
    expect(albums[3]).to have_content("Artist_Album-2")
  end

  scenario "lists artist albums alphabetically when 'name' is selected", js:true do
    click_on "Name"
    wait_for_js

    albums = page.all(".album")
    expect(albums[0]).to have_content("Artist_Album-1")
    expect(albums[1]).to have_content("Artist_Album-2")
    expect(albums[2]).to have_content("Artist_Album-3")
    expect(albums[3]).to have_content("Artist_Album-4")
  end
end
