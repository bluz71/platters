require "rails_helper"

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
      delete "/#{artist.slug}/comments/#{my_comment.id}.json",
             auth_headers(admin)

      expect(response).to be_successful
    end

    it "is disallowed if you did not post the comment" do
      delete "/#{artist.slug}/comments/#{not_my_comment.id}.json",
             auth_headers(user)

      expect(response.status).to eq 404
    end
  end

  context "from albums" do
    let!(:my_comment) do
      FactoryBot.create(:comment_for_album, commentable: album,
                        user: user, body: "My album comment")
    end

    let!(:not_my_comment) do
      FactoryBot.create(:comment_for_album, commentable: album,
                        body: "Not my album comment")
    end

    it "will succeed if you posted the comment and are logged in" do
      delete "/#{artist.slug}/#{album.slug}/comments/#{my_comment.id}.json",
             auth_headers(user)

      expect(response).to be_successful
    end

    it "will fail if are not logged in" do
      delete "/#{artist.slug}/#{album.slug}/comments/#{my_comment.id}.json"

      expect(response.status).to eq 401
    end

    it "will succeed when deleted by an admin" do
      delete "/#{artist.slug}/#{album.slug}/comments/#{my_comment.id}.json",
             auth_headers(admin)

      expect(response).to be_successful
    end

    it "is disallowed if you did not post the comment" do
      delete "/#{artist.slug}/#{album.slug}/comments/#{not_my_comment.id}.json",
             auth_headers(user)

      expect(response.status).to eq 404
    end
  end
end
