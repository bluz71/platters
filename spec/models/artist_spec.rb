require "rails_helper"

RSpec.describe Artist, type: :model do
  describe "#name" do
    let!(:artist) { FactoryGirl.create(:artist, name: "ABC") }

    it "when valid" do
      expect(artist).to be_valid
    end

    it "is unique" do
      artist2 = FactoryGirl.build(:artist, name: "ABC")
      expect(artist2).not_to be_valid
      expect(artist2.errors.messages[:name].first).to eq "has already been taken"
    end

    it "is case-insensitively unique" do
      artist2 = FactoryGirl.build(:artist, name: "aBc")
      expect(artist2).not_to be_valid
      expect(artist2.errors.messages[:name].first).to eq "has already been taken"
    end
  end

  describe "#website" do
    let(:artist) { FactoryGirl.build_stubbed(:artist) }

    it "is valid" do
      expect(artist).to be_valid
    end

    it "is invalid without protocol prefix" do
      artist.website = "www.artist.com"
      expect(artist).not_to be_valid
    end
  end

  describe "#website_link" do
    let(:artist) { FactoryGirl.build_stubbed(:artist) }

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

  describe "#list" do
    it "with letter prefix"
    it "with search term"
  end
end
