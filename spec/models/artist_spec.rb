require "rails_helper"

RSpec.describe Artist, type: :model do
  describe "#name" do
    let!(:artist) { FactoryBot.create(:artist, name: "ABC") }

    it "when valid" do
      expect(artist).to be_valid
    end

    it "is unique" do
      artist2 = FactoryBot.build(:artist, name: "ABC")
      expect(artist2).not_to be_valid
      expect(artist2.errors.messages[:name].first).to eq "has already been taken"
    end

    it "is case-insensitively unique" do
      artist2 = FactoryBot.build(:artist, name: "aBc")
      expect(artist2).not_to be_valid
      expect(artist2.errors.messages[:name].first).to eq "has already been taken"
    end
  end

  describe "#website" do
    let(:artist) { FactoryBot.build_stubbed(:artist) }

    it "is valid" do
      expect(artist).to be_valid
    end

    it "is invalid without protocol prefix" do
      artist.website = "www.artist.com"
      expect(artist).not_to be_valid
    end
  end

  describe "#website_link" do
    let(:artist) { FactoryBot.build_stubbed(:artist) }

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
    let!(:artist)  { FactoryBot.create(:artist, name: "ABC") }
    let!(:artist2) { FactoryBot.create(:artist, name: "DEF") }
    let!(:artist3) { FactoryBot.create(:artist, name: "XYZ", description: "definitely") }

    it "by letter prefix" do
      params = {}
      params[:letter] = "A"
      expect(Artist.list(params).map(&:name)).to eq ["ABC"]
    end

    it "by search term" do
      params = {}
      params[:search] = "XYZ"
      expect(Artist.list(params).map(&:name)).to eq ["XYZ"]
    end

    it "by search term is case insensitive" do
      params = {}
      params[:search] = "aBc"
      expect(Artist.list(params).map(&:name)).to eq ["ABC"]
    end

    it "by search ranks name matches higher then description matches" do
      params = {}
      params[:search] = "def"
      expect(Artist.list(params).map(&:name)).to eq ["DEF"]
    end
  end
end
