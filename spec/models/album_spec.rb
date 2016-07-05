require "rails_helper"

RSpec.describe Album, type: :model do
  describe "#title" do
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

  describe "#year" do
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

  describe "#tracks_list" do
    let(:album) { FactoryGirl.build_stubbed(:album_with_tracks) }

    it "when valid" do
      expect(album).to be_valid
      expect(album.tracks.size).to eq 3
      expect(album.track_list).to eq "Track-1 (3:08)\nTrack-2 (3:08)\nTrack-3 (3:08)"
    end
  end

  describe "#track_list=" do
    let(:album) { FactoryGirl.build_stubbed(:album) }

    it "when valid" do
      album.track_list = "Track 1 (2:13)\r\nTrack 2 (3:33)\r\nTrack 3 (4:45)"
      expect(album).to be_valid
      expect(album.tracks.size).to eq 3
      expect(album.tracks[0].title).to eq "Track 1"
      expect(album.tracks[0].duration).to eq 133
      expect(album.tracks[1].title).to eq "Track 2"
      expect(album.tracks[1].duration).to eq 213
      expect(album.tracks[2].title).to eq "Track 3"
      expect(album.tracks[2].duration).to eq 285
    end

    it "is invalid if duration is not provided" do
      album.track_list = "Track 1"
      expect(album).not_to be_valid
      expect(album.errors.messages[:track_list].first).to eq "format error, 1st track is either missing: " <<
                                                             "duration at the end of the line, or a whitespace before the duration"
    end

    it "is invalid if any track is missing duration" do
      album.track_list = "Track 1 (2:13)\r\nTrack 2\r\nTrack 3 (4:45)"
      expect(album).not_to be_valid
      expect(album.errors.messages[:track_list].first).to eq "format error, 2nd track is either missing: " <<
                                                             "duration at the end of the line, or a whitespace before the duration"
    end

    it "is invalid if seconds duration is greater than 60" do
      album.track_list = "Track 1 (2:61)"
      expect(album).not_to be_valid
      expect(album.errors.messages[:track_list].first).to eq "duration error, seconds can't exceed 59 for the 1st track"
    end
  end

  describe "#tracks_summary" do
    let(:album) { FactoryGirl.build_stubbed(:album) }

    it "lists first six tracks" do
      album.track_list = "Track 1 (2:13)\r\nTrack 2 (3:33)\r\nTrack 3 (4:45)\r\n" <<
                         "Track 4 (2:34)\r\nTrack 5 (2:55)\r\nTrack 6 (3:05)\r\nTrack 7 (3:17)"
      expect(album).to be_valid
      expect(album.tracks.size).to eq 7
      expect(album.tracks_summary).to eq ["1. Track 1", "2. Track 2", "3. Track 3",
                                          "4. Track 4", "5. Track 5", "6. Track 6"]
    end

    it "list all tracks if album has less than six tracks" do
      album.track_list = "Track 1 (2:13)\r\nTrack 2 (3:33)\r\nTrack 3 (4:45)"
      expect(album).to be_valid
      expect(album.tracks.size).to eq 3
      expect(album.tracks_summary).to eq ["1. Track 1", "2. Track 2", "3. Track 3"]
    end

    it "emits 'No tracks' for empty album" do
      expect(album.tracks.size).to eq 0
      expect(album.tracks_summary).to eq ["No tracks"]
    end
  end

  describe "#total_duration" do
    let(:album) { FactoryGirl.build_stubbed(:album) }

    it "computes album time length" do
      album.track_list = "Track 1 (2:13)\r\nTrack 2 (3:33)\r\nTrack 3 (4:15)"
      expect(album).to be_valid
      expect(album.total_duration).to eq("10:01")
    end
  end

  describe ".artist_albums" do
    let(:artist) { FactoryGirl.create(:artist) }

    let!(:album1) do
      FactoryGirl.create(:album, title: "Artist_Album-1",
                         artist: artist, year: 2005)
    end

    let!(:album2) do 
      FactoryGirl.create(:album, title: "Artist_Album-2",
                         artist: artist, year: 2010)
    end

    let!(:album3) do
      FactoryGirl.create(:album, title: "Artist_Album-3",
                         artist: artist, year: 2000)
    end

    it "lists artist albums in reverse chronological order" do
      expect(Album.artist_albums(artist.id).pluck(:title)).to eq ["Artist_Album-2",
                                                                  "Artist_Album-1",
                                                                  "Artist_Album-3"]
    end
  end
end
