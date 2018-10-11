require "rails_helper"

# Notes about API specs:
#   http://matthewlehner.net/rails-api-testing-guidelines

RSpec.describe "Removing Comments API" do
  let(:user)         { FactoryBot.create(:user) }
  let(:admin)        { FactoryBot.create(:admin) }
  let(:artist)       { FactoryBot.create(:artist) }
  let(:release_date) { FactoryBot.create(:release_date) }
  let(:album) do
    FactoryBot.create(:album, artist: artist, release_date: release_date)
  end

  context "from artists" do
    let!(:my_comment) do
      FactoryBot.create(:comment_for_artist, commentable: artist,
                        user: user, body: "My artist comment")
    end

    let!(:not_my_comment) do
      FactoryBot.create(:comment_for_artist, commentable: artist,
                        body: "Not my artist comment")
    end

    it "will succeed if you posted the comment and are logged in" do
      delete "/#{artist.slug}/comments/#{my_comment.id}.json",
             auth_headers(user)

      expect(response).to be_successful
    end

    it "will fail if are not logged in" do
      delete "/#{artist.slug}/comments/#{my_comment.id}.json"

      expect(response.status).to eq 401
    end

    it "will succeed when deleted by an admin" do

    end

    it "is disallowed if you did not post the comment" do
      
    end
  end

  context "from albums" do

  end
end
