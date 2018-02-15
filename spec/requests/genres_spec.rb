require "rails_helper"

# Notes about API specs:
#   http://matthewlehner.net/rails-api-testing-guidelines

RSpec.describe "Genres API" do
  before do
    FactoryBot.create(:genre, name: "Classical")
    FactoryBot.create(:genre, name: "Rock")
    FactoryBot.create(:genre, name: "Pop")
    FactoryBot.create(:genre, name: "Funk")
  end

  scenario "provides a list of all genres" do
    get "/genres.json"

    expect(response).to be_success
    expect(json_response["genres"].length).to eq 4
    expect(json_response["genres"][0]["name"]).to  eq "Classical"
    expect(json_response["genres"][1]["name"]).to  eq "Funk"
    expect(json_response["genres"][2]["name"]).to  eq "Pop"
    expect(json_response["genres"][3]["name"]).to  eq "Rock"
  end
end
