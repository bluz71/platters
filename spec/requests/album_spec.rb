require "rails_helper"

# Notes about API specs:
#   http://matthewlehner.net/rails-api-testing-guidelines

RSpec.describe "Album API" do
  let(:genre)         { FactoryBot.create(:genre, name: "Rock") }
  let(:artist)        { FactoryBot.create(:artist, name: "ABC") }
  let(:release_date)  { FactoryBot.create(:release_date, year: 2000) }
  let(:album) do
    FactoryBot.create(:album, title: "DEF", artist: artist,
                      release_date: release_date, genre: genre)
  end
  before do
    10.times do
      FactoryBot.create(:track, album: album)
    end
    30.times do
      FactoryBot.create(:comment_for_album, commentable: album, body: "Comment")
    end
  end

  it "provides album details" do
    get "/abc/def.json"

    expect(response).to be_successful
    expect(json_response["album"]["title"]).to eq "DEF"
    expect(json_response["album"]["artist_name"]).to eq "ABC"
    expect(json_response["album"]["track_count"]).to eq 10
    expect(json_response["album"]["genre"]).to eq "Rock"
    expect(json_response["album"]["year"]).to eq 2000
    expect(json_response["tracks"].length).to eq 10
    expect(json_response["comments"].length).to eq 25
    expect(json_response["comments_pagination"]["current_page"]).to eq 1
    expect(json_response["comments_pagination"]["next_page"]).to eq 2
    expect(json_response["comments_pagination"]["total_pages"]).to eq 2
    expect(json_response["comments_pagination"]["total_count"]).to eq 30
  end
end
