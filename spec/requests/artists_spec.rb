require "rails_helper"

# Notes about API specs:
#   http://matthewlehner.net/rails-api-testing-guidelines

RSpec.describe "Artists API" do
  before do
    FactoryBot.create(:artist, name: "ABC")
    FactoryBot.create(:artist, name: "XYZ")
    25.times { FactoryBot.create(:artist) }
  end

  scenario "provides a list of all artists" do
    get "/artists.json"

    expect(response).to be_success
    expect(json_response["artists"].length).to eq 25
    expect(json_response["artists"][0]["name"]).to  eq "ABC"
  end

  scenario "provides a list of paginated artists" do
    get "/artists.json?page=2"

    expect(response).to be_success
    expect(json_response["artists"].length).to eq 2
    expect(json_response["artists"][1]["name"]).to  eq "XYZ"
  end

  scenario "provides a list of artists filtered by letter" do
    get "/artists.json?letter=X"

    expect(response).to be_success
    expect(json_response["artists"].length).to eq 1
    expect(json_response["artists"][0]["name"]).to eq "XYZ"
  end
end
