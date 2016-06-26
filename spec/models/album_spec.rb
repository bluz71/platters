require "rails_helper"

RSpec.describe Album, type: :model do
  context "#title" do
    let(:album) { FactoryGirl.build_stubbed(:album, title: "Album") }

    it "when valid" do
      expect(album).to be_valid
      expect(album.title).to eq "Album"
    end

    it "is invalid when blank" do
      album.title = ""
      expect(album).not_to be_valid
    end
  end

  context "#year" do
    let(:album) { FactoryGirl.build_stubbed(:album, year: 2001, skip_year: false) }

    it "when valid" do
      expect(album).to be_valid
      expect(album.year).to eq 2001
    end

    it "is invalid when less than 1940" do
      album.year = 1930
      expect(album).not_to be_valid
    end

    it "is invalid when greater than current year" do
      album.year = Date.current.year + 1
      expect(album).not_to be_valid
    end
  end

  context "#tracks_list" do
    let(:album) { FactoryGirl.build_stubbed(:album) }

    it "when valid" do
      album.tracks_list = "Track 1 (2:13)\r\nTrack 2 (3:33)\r\nTrack 3 (4:45)"
      expect(album).to be_valid
      expect(album.tracks.size).to eq 3
    end

    it "is invalid if duration is not provided" do
      album.tracks_list = "Track 1"
      expect(album).not_to be_valid
      expect(album.errors.messages[:tracks_list].first).to eq "format error, 1st track is missing duration, in (mins:secs) format, at the end of the line"
    end

    it "is invalid if any track is missing duration" do
      album.tracks_list = "Track 1 (2:13)\r\nTrack 2\r\nTrack 3 (4:45)"
      expect(album).not_to be_valid
      expect(album.errors.messages[:tracks_list].first).to eq "format error, 2nd track is missing duration, in (mins:secs) format, at the end of the line"
    end

    it "is invalid if seconds duration is greater than 60" do
      album.tracks_list = "Track 1 (2:61)"
      expect(album).not_to be_valid
      expect(album.errors.messages[:tracks_list].first).to eq "duration error, seconds can't exceed 59 for the 1st track"
    end
  end

  context "#tracks_summary" do
    it "lists first six tracks"
    it "list all tracks if album has less than six tracks"
    it "emits 'No tracks' for empty album"
  end

  context "#total_duration" do
    it "computes album time length"
  end

  context ".artist_albums" do
    it "lists artist albums in reverse chronological order"
  end
end
