require "rails_helper"

# Notes about API specs:
#   http://matthewlehner.net/rails-api-testing-guidelines

RSpec.describe "Artists API" do
  before do
    FactoryBot.create(:artist, name: "ABC")
    23.times { FactoryBot.create(:artist) }
    FactoryBot.create(:artist, name: "XYZ")
  end

  scenario "provides a list of artists" do
    get "/artists.json"

    expect(response).to be_success
    expect(json_response["artists"].length).to eq 25
    expect(json_response["artists"][0]["name"]).to  eq "ABC"
    expect(json_response["artists"][24]["name"]).to eq "XYZ"
  end
end
