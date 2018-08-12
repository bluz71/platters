require "rails_helper"

# Notes about API specs:
#   http://matthewlehner.net/rails-api-testing-guidelines

RSpec.describe "Artist Comments API" do
  let(:artist) do
    FactoryBot.create(:artist, name: "ABC", description: "ABC Band",
                      wikipedia: "abc_band", website: "https://abc_band.com")
  end
  before do
    30.times do
      FactoryBot.create(:comment_for_artist, commentable: artist, body: "Comment")
    end
  end

  it "provides comments for an album" do
    get "/abc/comments.json"

    expect(response).to be_successful
    expect(json_response["comments"].length).to eq 25
    expect(json_response["pagination"]["current_page"]).to eq 1
    expect(json_response["pagination"]["next_page"]).to eq 2
    expect(json_response["pagination"]["total_pages"]).to eq 2
    expect(json_response["pagination"]["total_count"]).to eq 30
  end

  it "provides paginated comments for an artist" do
    get "/abc/comments.json?page=2"

    expect(response).to be_successful
    expect(json_response["comments"].length).to eq 5
    expect(json_response["pagination"]["current_page"]).to eq 2
    expect(json_response["pagination"]["total_pages"]).to eq 2
    expect(json_response["pagination"]["total_count"]).to eq 30
  end
end
