require "rails_helper"

RSpec.describe Album, type: :model do
  describe "#title" do
    let(:artist) { FactoryBot.create(:artist) }
    let(:album) do
      FactoryBot.create(:album, title: "Album", artist: artist)
    end

    it "when valid" do
      expect(album).to be_valid
      expect(album.title).to eq "Album"
    end

    it "is invalid when blank" do
      album.title = ""
      expect(album).not_to be_valid
    end

    it "is invalid when album title is not unique per artist" do
      artist2 = FactoryBot.create(:artist)
      album2 = FactoryBot.create(:album, title: "Album", artist: artist2)
      expect(album).to be_valid

      album2.artist = artist
      expect(album2).not_to be_valid
      expect(album2.errors.messages[:title].first).to eq "has already been taken"
    end
  end

  describe "#year" do
    let(:album) { FactoryBot.build_stubbed(:album, year: 2001, skip_year: false) }

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
    let(:album) { FactoryBot.create(:album_with_tracks) }

    it "when valid" do
      expect(album).to be_valid
      expect(album.tracks.size).to eq 3
      expect(album.track_list).to \
        match(/Track-[\d]+ \(3:08\)\nTrack-[\d]+ \(3:08\)\nTrack-[\d]+ \(3:08\)/)
    end
  end

  describe "#track_list=" do
    let(:album) { FactoryBot.create(:album) }

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
      expect(album.errors.messages[:track_list].first).to eq \
        "format error, 1st track is either missing: "\
        "duration at the end of the line, or a whitespace before the duration"
    end

    it "is invalid if any track is missing duration" do
      album.track_list = "Track 1 (2:13)\r\nTrack 2\r\nTrack 3 (4:45)"
      expect(album).not_to be_valid
      expect(album.errors.messages[:track_list].first).to eq \
        "format error, 2nd track is either missing: "\
        "duration at the end of the line, or a whitespace before the duration"
    end

    it "is invalid if seconds duration is greater than 60" do
      album.track_list = "Track 1 (2:61)"
      expect(album).not_to be_valid
      expect(album.errors.messages[:track_list].first).to eq \
        "duration error, seconds can't exceed 59 for the 1st track"
    end
  end

  describe "#tracks_summary" do
    let(:album) { FactoryBot.create(:album) }

    it "lists first six tracks" do
      album.track_list = "Track 1 (2:13)\r\nTrack 2 (3:33)\r\nTrack 3 (4:45)\r\n"\
                         "Track 4 (2:34)\r\nTrack 5 (2:55)\r\nTrack 6 (3:05)\r\n"\
                         "Track 7 (3:17)"
      expect(album).to be_valid
      expect(album.tracks.size).to eq 7
      expect(album.tracks_summary).to eq ["1. Track 1", "2. Track 2", "3. Track 3",
                                          "4. Track 4", "5. Track 5", "6. Track 6",
                                          "..."]
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
    let(:album) { FactoryBot.create(:album) }

    it "computes album time length" do
      album.track_list = "Track 1 (2:13)\r\nTrack 2 (3:33)\r\nTrack 3 (4:15)"
      expect(album).to be_valid
      expect(album.total_duration).to eq("10:01")
    end
  end

  describe "#list" do
    let(:genre) { FactoryBot.create(:genre, name: "Rock") }

    let!(:album) do
      FactoryBot.create(:album, title: "ABC", year: 1990)
    end

    let!(:album2) do
      FactoryBot.create(:album, title: "DEF", genre: genre, year: 2010)
    end

    let!(:album3) do
      FactoryBot.create(:album, title: "XYZ", genre: genre, year: 2005)
    end

    let(:params) { {} }

    it "by search term" do
      params[:search] = "XYZ"
      expect(Album.list(params).map(&:title)).to eq ["XYZ"]
    end

    it "by search term is case insensitive" do
      params[:search] = "aBc"
      expect(Album.list(params).map(&:title)).to eq ["ABC"]
    end

    it "by search ranks album title matches higher than track title matches" do
      album3.track_list = "Definitely 1 (3:22)"
      album3.save
      params[:search] = "def"
      expect(Album.list(params).map(&:title)).to eq %w(DEF XYZ)
    end

    it "by randomization" do
      params[:random] = true
      default_order = %w(ABC DEF XYZ)
      same_as_default = true
      10.times do
        randomized = Album.list(params).map(&:title)
        if randomized != default_order
          same_as_default = false
          break
        end
      end
      expect(same_as_default).not_to be_truthy
    end

    it "by letter prefix" do
      params[:letter] = "A"
      expect(Album.list(params).map(&:title)).to eq ["ABC"]
    end

    it "by genre" do
      params[:genre] = "Rock"
      expect(Album.list(params).map(&:title)).to eq %w(DEF XYZ)
    end

    it "by year" do
      params[:year] = "2005"
      expect(Album.list(params).map(&:title)).to eq ["XYZ"]
    end

    it "by genre with matching letter" do
      params[:genre] = "Rock"
      params[:letter] = "D"
      expect(Album.list(params).map(&:title)).to eq ["DEF"]
    end

    it "by genre with no matching letter" do
      params[:genre] = "Rock"
      params[:letter] = "E"
      expect(Album.list(params).map(&:title)).to eq []
    end

    it "by genre sorted by year" do
      params[:genre] = "Rock"
      params[:sort] = "year"
      expect(Album.list(params).map(&:title)).to eq %w(XYZ DEF)
    end

    it "by genre reversed" do
      params[:genre] = "Rock"
      params[:order] = "reverse"
      expect(Album.list(params).map(&:title)).to eq %w(XYZ DEF)
    end

    it "by year with matching letter" do
      params[:year] = "2005"
      params[:letter] = "X"
      expect(Album.list(params).map(&:title)).to eq ["XYZ"]
    end

    it "all sorted by title" do
      expect(Album.list(params).map(&:title)).to eq %w(ABC DEF XYZ)
    end

    it "all sorted by title reversed" do
      params[:order] = "reverse"
      expect(Album.list(params).map(&:title)).to eq %w(XYZ DEF ABC)
    end

    it "all sorted by year" do
      params[:sort] = "year"
      expect(Album.list(params).map(&:title)).to eq %w(ABC XYZ DEF)
    end

    it "all sorted by year reversed" do
      params[:sort] = "year"
      params[:order] = "reverse"
      expect(Album.list(params).map(&:title)).to eq %w(DEF XYZ ABC)
    end
  end

  describe "most_recent scope" do
    let(:artist)        { FactoryBot.create(:artist, name: "ABC") }
    let(:release_date1) { FactoryBot.create(:release_date, year: Date.current.year) }
    let(:release_date2) { FactoryBot.create(:release_date, year: Date.current.year - 1) }

    before do
      (1..3).each do |i|
        FactoryBot.create(:album, title: "Foo-#{i}", artist: artist,
                          release_date: release_date1)
      end
      FactoryBot.create(:album, title: "Foo-4", artist: artist,
                        release_date: release_date2)
      (5..7).each do |i|
        FactoryBot.create(:album, title: "Foo-#{i}", artist: artist,
                          release_date: release_date2)
      end
    end

    it "lists the five newest albums" do
      expect(Album.most_recent.map(&:title)).to eq ["Foo-3", "Foo-2", "Foo-1",
                                                    "Foo-7", "Foo-6", "Foo-5"]
    end
  end

  describe "spotlight scope" do
    it "returns a random album" do
      5.times { FactoryBot.create(:album) }

      same_as_last_time = true
      spotlight_album = Album.spotlight
      10.times do
        new_spotlight_album = Album.spotlight
        if spotlight_album != new_spotlight_album
          same_as_last_time = false
          break
        end
      end

      expect(same_as_last_time).not_to be_truthy
    end
  end

  describe ".artist_albums" do
    let(:artist) { FactoryBot.create(:artist) }

    let!(:album1) do
      FactoryBot.create(:album, title: "Artist_Album-1",
                        artist: artist, year: 2005)
    end

    let!(:album2) do
      FactoryBot.create(:album, title: "Artist_Album-2",
                        artist: artist, year: 2010)
    end

    let!(:album3) do
      FactoryBot.create(:album, title: "Artist_Album-3",
                        artist: artist, year: 2000)
    end

    let!(:album4) do
      FactoryBot.create(:album, title: "Artist_Album-4",
                        artist: artist, year: 1995)
    end

    it "lists artist albums in reverse chronological order by default" do
      expect(Album.artist_albums(artist.id).map(&:title)).to eq ["Artist_Album-2",
                                                                 "Artist_Album-1",
                                                                 "Artist_Album-3",
                                                                 "Artist_Album-4"]
    end

    it "lists artist albums newest to oldest when 'newest' is selected" do
      params = {}
      params[:newest] = true
      expect(Album.artist_albums(artist.id, params).map(&:title)).to eq ["Artist_Album-2",
                                                                         "Artist_Album-1",
                                                                         "Artist_Album-3",
                                                                         "Artist_Album-4"]
    end

    it "lists artist albums oldest to newest when 'oldest' is selected" do
      params = {}
      params[:oldest] = true
      expect(Album.artist_albums(artist.id, params).map(&:title)).to eq ["Artist_Album-4",
                                                                         "Artist_Album-3",
                                                                         "Artist_Album-1",
                                                                         "Artist_Album-2"]
    end

    it "lists artist albums longest to shortest when 'longest' is selected" do
      album1.track_list = "Track 1 (3:22)"
      album1.save
      album2.track_list = "Track 1 (2:41)"
      album2.save
      album3.track_list = "Track 1 (5:42)"
      album3.save
      album4.track_list = "Track 1 (1:58)"
      album4.save
      params = {}
      params[:longest] = true
      expect(Album.artist_albums(artist.id, params).map(&:title)).to eq ["Artist_Album-3",
                                                                         "Artist_Album-1",
                                                                         "Artist_Album-2",
                                                                         "Artist_Album-4"]
    end

    it "lists artist albums alphabetically when 'name' is selected" do
      params = {}
      params[:name] = true
      expect(Album.artist_albums(artist.id, params).map(&:title)).to eq ["Artist_Album-1",
                                                                         "Artist_Album-2",
                                                                         "Artist_Album-3",
                                                                         "Artist_Album-4"]
    end
  end
end
