require "rails_helper"

RSpec.describe "Showing artist albums", type: :system do
  let(:artist) { FactoryBot.create(:artist) }

  let!(:album1) do
    FactoryBot.create(:album, title: "Artist_Album-1",
                      artist: artist, year: 2005)
  end

  let!(:album2) do
    FactoryBot.create(:album, title: "Artist_Album-2",
                      artist: artist, year: 2010)
  end

  let!(:album3) do
    FactoryBot.create(:album, title: "Artist_Album-3",
                      artist: artist, year: 2000)
  end

  let!(:album4) do
    FactoryBot.create(:album, title: "Artist_Album-4",
                      artist: artist, year: 1995)
  end

  before do
    visit artist_path(artist)
    FactoryBot.create(:track, duration: 600, album: album1)
    FactoryBot.create(:track, duration: 200, album: album4)
    FactoryBot.create(:track, duration: 100, album: album3)
    FactoryBot.create(:track, duration: 50, album: album2)
  end

  it "lists artist albums in reverse chronological order by default" do
    albums = page.all(".album")
    expect(albums[0]).to have_content "Artist_Album-2"
    expect(albums[1]).to have_content "Artist_Album-1"
    expect(albums[2]).to have_content "Artist_Album-3"
    expect(albums[3]).to have_content "Artist_Album-4"
  end

  it "lists artist albums newest to oldest when 'newest' is selected", js: true do
    click_on "Newest"
    wait_for_js

    albums = page.all(".album")
    expect(albums[0]).to have_content "Artist_Album-2"
    expect(albums[1]).to have_content "Artist_Album-1"
    expect(albums[2]).to have_content "Artist_Album-3"
    expect(albums[3]).to have_content "Artist_Album-4"
  end

  it "lists artist albums oldest to newest when 'oldest' is selected", js: true do
    click_on "Oldest"
    wait_for_js

    albums = page.all(".album")
    expect(albums[0]).to have_content "Artist_Album-4"
    expect(albums[1]).to have_content "Artist_Album-3"
    expect(albums[2]).to have_content "Artist_Album-1"
    expect(albums[3]).to have_content "Artist_Album-2"
  end

  it "lists artist albums longest to shortest when 'longest' is "\
           "selected", js: true do
    click_on "Longest"
    wait_for_js

    albums = page.all(".album")
    expect(albums[0]).to have_content "Artist_Album-1"
    expect(albums[1]).to have_content "Artist_Album-4"
    expect(albums[2]).to have_content "Artist_Album-3"
    expect(albums[3]).to have_content "Artist_Album-2"
  end

  it "lists artist albums alphabetically when 'name' is selected", js: true do
    click_on "Name"
    wait_for_js

    albums = page.all(".album")
    expect(albums[0]).to have_content "Artist_Album-1"
    expect(albums[1]).to have_content "Artist_Album-2"
    expect(albums[2]).to have_content "Artist_Album-3"
    expect(albums[3]).to have_content "Artist_Album-4"
  end
end
