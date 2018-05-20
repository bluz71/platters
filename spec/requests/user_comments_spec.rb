require "rails_helper"

# Notes about API specs:
#   http://matthewlehner.net/rails-api-testing-guidelines

RSpec.describe "User Comments API" do
  let(:user)  { FactoryBot.create(:user) }
  let(:artist) { FactoryBot.create(:artist) }

  before do
    FactoryBot.create(:comment_for_artist, commentable: artist, user: user,
                      body: "First comment")
    28.times do
      FactoryBot.create(:comment_for_artist, commentable: artist, user: user,
                        body: "A comment")
    end
    FactoryBot.create(:comment_for_artist, commentable: artist, user: user,
                      body: "Newest comment")
  end

  scenario "provides a list of user comments" do
    get "/comments/#{user.slug}.json"

    expect(response).to be_successful
    expect(json_response["comments"].length).to eq 25
    expect(json_response["comments"][0]["body"]).to eq "Newest comment"
  end

  scenario "provides a list of paginated comments" do
    get "/comments/#{user.slug}.json?page=2"

    expect(response).to be_successful
    expect(json_response["comments"].length).to eq 5
    expect(json_response["comments"][4]["body"]).to eq "First comment"
  end

  scenario "responds with 404 for invalid user" do
    get "/comments/invalid_user.json"

    expect(response.status).to eq 404
  end
end
