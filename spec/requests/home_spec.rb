require "rails_helper"

RSpec.describe "Home API" do
  let(:genre) { FactoryBot.create(:genre, name: "Rock") }
  let(:artist) { FactoryBot.create(:artist, name: "Artist") }
  let(:release_date) { FactoryBot.create(:release_date, year: Date.current.year) }
  let(:album) do
    FactoryBot.create(
      :album, title: "ABC", artist: artist, release_date: release_date
    )
  end

  before do
    10.times do
      FactoryBot.create(:album, artist: artist, release_date: release_date)
    end
    12.times do
      FactoryBot.create(:comment_for_artist, commentable: artist, body: "Comment")
    end
  end

  it "provides home page resources" do
    FactoryBot.create(
      :comment_for_artist, commentable: artist, body: "New comment"
    )
    expect(Album).to receive(:spotlight) { album }
    get "/home.json"

    expect(response).to be_successful
    expect(json_response["album_of_the_day"]["title"]).to eq "ABC"
    expect(json_response["most_recent"]["albums"].length).to eq 6
    expect(json_response["most_recent"]["albums"][0]["title"]).to eq "ABC"
    expect(json_response["most_recent"]["comments"].length).to eq 10
    expect(json_response["most_recent"]["comments"][0]["body"]).to eq "New comment"
  end
end
