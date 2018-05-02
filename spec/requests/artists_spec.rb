require "rails_helper"

# Notes about API specs:
#   http://matthewlehner.net/rails-api-testing-guidelines

RSpec.describe "Artists API" do
  let(:artist)       { FactoryBot.create(:artist, name: "ABC") }
  let(:release_date) { FactoryBot.create(:release_date, year: Date.current.year) }

  before do
    FactoryBot.create(:artist, name: "XYZ")
    25.times { FactoryBot.create(:artist) }
    8.times do
      FactoryBot.create(:album, artist: artist, release_date: release_date)
    end
    FactoryBot.create(:album, title: "Last", artist: artist, release_date: release_date)
    12.times do
      FactoryBot.create(:comment_for_artist, commentable: artist, body: "Comment")
    end
  end

  scenario "provides a list of all artists" do
    get "/artists.json"

    expect(response).to be_successful
    expect(json_response["artists"].length).to eq 25
    expect(json_response["artists"][0]["name"]).to eq "ABC"
  end

  scenario "provides a list of most recent albums" do
    get "/artists.json"

    expect(response).to be_successful
    expect(json_response["most_recent"]["albums"].length).to eq 6
    expect(json_response["most_recent"]["albums"][0]["title"]).to eq "Last"
  end

  scenario "provides a list of most recent comments" do
    get "/artists.json"

    expect(response).to be_successful
    expect(json_response["most_recent"]["comments"].length).to eq 10
  end

  scenario "provides a list of paginated artists" do
    get "/artists.json?page=2"

    expect(response).to be_successful
    expect(json_response["artists"].length).to eq 2
    expect(json_response["artists"][1]["name"]).to eq "XYZ"
  end

  scenario "provides a list of artists filtered by letter" do
    get "/artists.json?letter=X"

    expect(response).to be_successful
    expect(json_response["artists"].length).to eq 1
    expect(json_response["artists"][0]["name"]).to eq "XYZ"
  end
end
