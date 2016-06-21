require "rails_helper"

RSpec.describe Artist, type: :model do
  context "naming" do
    let!(:artist) { FactoryGirl.create(:artist, name: "ABC") }

    it "successfully" do
      expect(artist.errors.messages.any?).to be_falsy
      expect(Artist.first.name).to eq "ABC"
    end

    it "must be unique" do
      artist2 = Artist.create(name: "ABC")
      expect(artist2.errors.messages.any?).to be_truthy
      expect(artist2.errors.messages[:name].first).to eq "has already been taken"
    end

    it "must be case-insensitive unique" do
      artist2 = Artist.create(name: "aBc")
      expect(artist2.errors.messages.any?).to be_truthy
      expect(artist2.errors.messages[:name].first).to eq "has already been taken"
    end
  end

  context "website" do
    let(:artist) { FactoryGirl.create(:artist) }

    context "validation" do
      it "when correct" do
        expect(artist).to be_valid
      end

      it "when incorrect" do
        artist.website = "www.artist.com"
        expect(artist).not_to be_valid
      end
    end

    context "link" do
      it "with full URL" do
        expect(artist.website_link).to eq "artist.com"
      end

      it "with full SSL URL" do
        artist.website = "https://www.artist2.com"
        expect(artist.website_link).to eq "artist2.com"
      end

      it "without www URLS" do
        artist.website = "http://artist3.com"
        expect(artist.website_link).to eq "artist3.com"
      end
    end
  end
end
