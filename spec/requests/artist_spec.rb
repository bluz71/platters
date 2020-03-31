require "rails_helper"

RSpec.describe "Artist API" do
  let(:artist) do
    FactoryBot.create(
      :artist, name: "ABC", description: "ABC Band", wikipedia: "abc_band",
               website: "https://abc_band.com"
    )
  end
  let(:genre) { FactoryBot.create(:genre, name: "Rock") }
  let(:release_date) { FactoryBot.create(:release_date, year: 2000) }
  let(:album) do
    FactoryBot.create(
      :album, title: "DEF", artist: artist, release_date: release_date,
              genre: genre
    )
  end
  before do
    10.times do
      FactoryBot.create(:track, album: album)
    end
    FactoryBot.create(:comment_for_album, commentable: album, body: "Comment")
    30.times do
      FactoryBot.create(:comment_for_artist, commentable: artist, body: "Comment")
    end
  end

  it "provides artist details" do
    get "/abc.json"

    expect(response).to be_successful
    expect(json_response["artist"]["name"]).to eq "ABC"
    expect(json_response["artist"]["description"]).to eq "ABC Band"
    expect(json_response["artist"]["wikipedia"]).to eq "abc_band"
    expect(json_response["artist"]["website"]).to eq "https://abc_band.com"
    expect(json_response["artist"]["website_link"]).to eq "abc_band.com"
    expect(json_response["artist"]["slug"]).to eq "abc"
    expect(json_response["albums"].length).to eq 1
    expect(json_response["albums"][0]["title"]).to eq "DEF"
    expect(json_response["albums"][0]["tracks_count"]).to eq 10
    expect(json_response["albums"][0]["comments_count"]).to eq 1
    expect(json_response["comments"].length).to eq 25
    expect(json_response["comments_pagination"]["current_page"]).to eq 1
    expect(json_response["comments_pagination"]["next_page"]).to eq 2
    expect(json_response["comments_pagination"]["total_pages"]).to eq 2
    expect(json_response["comments_pagination"]["total_count"]).to eq 30
  end

  it "responds with not-found for invalid artist request" do
    get "/xyz.json"

    expect(response.status).to eq 404
  end
end
