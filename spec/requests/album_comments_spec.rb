require "rails_helper"

# Notes about API specs:
#   http://matthewlehner.net/rails-api-testing-guidelines

RSpec.describe "Album Comments API" do
  let(:genre) { FactoryBot.create(:genre, name: "Rock") }
  let(:artist) { FactoryBot.create(:artist, name: "ABC") }
  let(:release_date) { FactoryBot.create(:release_date, year: 2000) }
  let(:album) do
    FactoryBot.create(
      :album, title: "DEF", artist: artist, release_date: release_date,
              genre: genre
    )
  end
  before do
    30.times do
      FactoryBot.create(:comment_for_album, commentable: album, body: "Comment")
    end
  end

  it "provides comments for an album" do
    get "/abc/def/comments.json"

    expect(response).to be_successful
    expect(json_response["comments"].length).to eq 25
    expect(json_response["pagination"]["current_page"]).to eq 1
    expect(json_response["pagination"]["next_page"]).to eq 2
    expect(json_response["pagination"]["total_pages"]).to eq 2
    expect(json_response["pagination"]["total_count"]).to eq 30
  end

  it "provides paginated comments for an album" do
    get "/abc/def/comments.json?page=2"

    expect(response).to be_successful
    expect(json_response["comments"].length).to eq 5
    expect(json_response["pagination"]["current_page"]).to eq 2
    expect(json_response["pagination"]["total_pages"]).to eq 2
    expect(json_response["pagination"]["total_count"]).to eq 30
  end
end
