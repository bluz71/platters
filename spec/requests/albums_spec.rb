require "rails_helper"

# Notes about API specs:
#   http://matthewlehner.net/rails-api-testing-guidelines

RSpec.describe "Albums API" do
  let(:genre)         { FactoryBot.create(:genre, name: "Rock") }
  let(:artist)        { FactoryBot.create(:artist, name: "Artist") }
  let(:release_date)  { FactoryBot.create(:release_date, year: 2000) }
  let(:release_date2) { FactoryBot.create(:release_date, year: 2010) }

  before do
    FactoryBot.create(:album, title: "ABC", artist: artist,
                      release_date: release_date, genre: genre)
    FactoryBot.create(:album, title: "DEF", artist: artist,
                      release_date: release_date, genre: genre)
    FactoryBot.create(:album, title: "XYZ", artist: artist,
                      release_date: release_date)
    25.times do
      FactoryBot.create(:album, artist: artist, release_date: release_date2)
    end
  end

  scenario "provides a list of all albums" do
    get "/albums.json"

    expect(response).to be_successful
    expect(json_response["albums"].length).to eq 20
    expect(json_response["albums"][0]["title"]).to eq "ABC"
  end

  scenario "provides a list of paginated albums" do
    get "/albums.json?page=2"

    expect(response).to be_successful
    expect(json_response["albums"].length).to eq 8
    expect(json_response["albums"][7]["title"]).to eq "XYZ"
  end

  scenario "provides a list of albums filtered by letter" do
    get "/albums.json?letter=X"
    expect(response).to be_successful
    expect(json_response["albums"].length).to eq 1
    expect(json_response["albums"][0]["title"]).to eq "XYZ"
  end

  scenario "provides a list of albums filtered by genre" do
    get "/albums.json?genre=Rock"

    expect(response).to be_successful
    expect(json_response["albums"].length).to eq 2
    expect(json_response["albums"][0]["title"]).to  eq "ABC"
    expect(json_response["albums"][1]["title"]).to  eq "DEF"
  end

  scenario "provides a list of albums filtered by year" do
    get "/albums.json?year=2000"
    expect(json_response["albums"].length).to eq 3
    expect(json_response["albums"][0]["title"]).to  eq "ABC"
    expect(json_response["albums"][1]["title"]).to  eq "DEF"
    expect(json_response["albums"][2]["title"]).to  eq "XYZ"
  end
end
