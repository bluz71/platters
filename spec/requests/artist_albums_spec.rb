require "rails_helper"

# Notes about API specs:
#   http://matthewlehner.net/rails-api-testing-guidelines

RSpec.describe "Artist Albums API" do
  let(:artist)        { FactoryBot.create(:artist, name: "ABC") }
  let(:release_date)  { FactoryBot.create(:release_date, year: 2000) }
  let(:release_date2) { FactoryBot.create(:release_date, year: 1990) }
  let(:album) do
    FactoryBot.create(:album, title: "DEF", artist: artist,
                      release_date: release_date)
  end
  let(:album2) do
    FactoryBot.create(:album, title: "XYZ", artist: artist,
                      release_date: release_date2)
  end
  before do
    FactoryBot.create(:track, album: album)
    FactoryBot.create(:track, album: album)
    FactoryBot.create(:track, album: album2)
  end

  it "provides albums sorted by oldest" do
    get "/artists/abc/albums.json?oldest=true"

    expect(response).to be_successful
    expect(json_response["albums"].length).to eq 2
    expect(json_response["albums"][0]["title"]).to eq "XYZ"
    expect(json_response["albums"][1]["title"]).to eq "DEF"
  end

  it "provides albums sorted by newest" do
    get "/artists/abc/albums.json?newest=true"

    expect(response).to be_successful
    expect(json_response["albums"].length).to eq 2
    expect(json_response["albums"][0]["title"]).to eq "DEF"
    expect(json_response["albums"][1]["title"]).to eq "XYZ"
  end

  it "provides albums sorted by longest" do
    get "/artists/abc/albums.json?longest=true"

    expect(response).to be_successful
    expect(json_response["albums"].length).to eq 2
    expect(json_response["albums"][0]["title"]).to eq "DEF"
    expect(json_response["albums"][1]["title"]).to eq "XYZ"
  end

  it "provides albums sorted by name" do
    get "/artists/abc/albums.json?name=true"

    expect(response).to be_successful
    expect(json_response["albums"].length).to eq 2
    expect(json_response["albums"][0]["title"]).to eq "DEF"
    expect(json_response["albums"][1]["title"]).to eq "XYZ"
  end
end
