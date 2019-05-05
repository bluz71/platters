require "rails_helper"

RSpec.describe "Addings Comments API" do
  let(:user)         { FactoryBot.create(:user) }
  let(:admin)        { FactoryBot.create(:admin) }
  let(:artist)       { FactoryBot.create(:artist) }
  let(:release_date) { FactoryBot.create(:release_date) }
  let(:album) do
    FactoryBot.create(:album, artist: artist, release_date: release_date)
  end

  context "to artists" do
    it "is not possible for anonymous users" do
      payload = {"comment" => {"body" => "An artist comment"}}
      post "/#{artist.slug}/comments.json",
           params: payload.to_json

      expect(response.status).to eq 401
      expect(artist.comments.count).to eq 0
    end

    it "when posted with valid text" do
      payload = {"comment" => {"body" => "An artist comment"}}
      post "/#{artist.slug}/comments.json",
           params: payload.to_json,
           headers: auth_headers(user)

      expect(response).to be_successful
      expect(artist.comments.count).to eq 1
    end

    it "is not allowed with a blank comment" do
      payload = {"comment" => {"body" => ""}}
      post "/#{artist.slug}/comments.json",
           params: payload.to_json,
           headers: auth_headers(user)

      expect(response.status).to eq 403
      expect(json_response["error"]).to include "Comment is too short"
      expect(artist.comments.count).to eq 0
    end

    it "is not allowed for a comment with greater than 280 characters" do
      payload = {"comment" => {"body" => "a" * 281}}
      post "/#{artist.slug}/comments.json",
           params: payload.to_json,
           headers: auth_headers(user)

      expect(response.status).to eq 403
      expect(json_response["error"]).to include "Comment is too long"
      expect(artist.comments.count).to eq 0
    end

    it "is not allowed when a user has 100 or more comments today" do
      travel_to Time.parse("12AM") do
        100.times { artist.comments.create(user: user, body: "Comment") }
        payload = {"comment" => {"body" => "An artist comment"}}
        post "/#{artist.slug}/comments.json",
             params: payload.to_json,
             headers: auth_headers(user)

        expect(response.status).to eq 403
        expect(json_response["error"]).to include "User limit of 100 comments"
        expect(artist.comments.count).to eq 100
      end
    end
  end

  context "to albums" do
    it "is not possible for anonymous users" do
      payload = {"comment" => {"body" => "An album comment"}}
      post "/#{artist.slug}/#{album.slug}/comments.json",
           params: payload.to_json

      expect(response.status).to eq 401
      expect(album.comments.count).to eq 0
    end

    it "when posted with valid text" do
      payload = {"comment" => {"body" => "An album comment"}}
      post "/#{artist.slug}/#{album.slug}/comments.json",
           params: payload.to_json,
           headers: auth_headers(user)

      expect(response).to be_successful
      expect(album.comments.count).to eq 1
    end

    it "is not allowed with a blank comment" do
      payload = {"comment" => {"body" => ""}}
      post "/#{artist.slug}/#{album.slug}/comments.json",
           params: payload.to_json,
           headers: auth_headers(user)

      expect(response.status).to eq 403
      expect(json_response["error"]).to include "Comment is too short"
      expect(album.comments.count).to eq 0
    end

    it "is not allowed for a comment with greater than 280 characters" do
      payload = {"comment" => {"body" => "a" * 281}}
      post "/#{artist.slug}/#{album.slug}/comments.json",
           params: payload.to_json,
           headers: auth_headers(user)

      expect(response.status).to eq 403
      expect(json_response["error"]).to include "Comment is too long"
      expect(album.comments.count).to eq 0
    end

    it "is not allowed when a user has 100 or more comments today" do
      travel_to Time.parse("12AM") do
        100.times { album.comments.create(user: user, body: "Comment") }
        payload = {"comment" => {"body" => "An album comment"}}
        post "/#{artist.slug}/#{album.slug}/comments.json",
             params: payload.to_json,
             headers: auth_headers(user)

        expect(response.status).to eq 403
        expect(json_response["error"]).to include "User limit of 100 comments"
        expect(album.comments.count).to eq 100
      end
    end
  end
end
