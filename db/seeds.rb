# Raw Artist list:
#  % for i in $(find . -name '01*.mp3'); do mediainfo $i | grep "^Performer"; done | sort | uniq
#
# Raw Album list:
#  % for i in $(find . -name '01*.mp3' | sort); do mediainfo $i | grep "^Performer\|^Album \|^Recorded\|^Genre";echo; done
#
# Raw Track list:
#  % for i in $(find . -name '*.mp3' | sort); do mediainfo $i | grep "^Performer\|^Album \|^Track\ name\|^Duration";echo; done

MINUTES_RE = /\A\d+mn\z/
SECONDS_RE = /\A\d+s\z/

def to_seconds(duration)
  vals = duration.split
  raise "Unexpected number of duration values: #{vals.size} for #{duration}" unless vals.size == 2

  secs = 0
  vals.each do |val|
    if MINUTES_RE.match(val)
      secs += (val.to_i * 60) 
    elsif SECONDS_RE.match(val)
      secs += val.to_i
    end
  end
  secs
end

artists_seeds = Rails.root.join("db", "seeds", "artists.yml")
artists = YAML::load_file(artists_seeds)
artists.each do |artist|
  Artist.find_or_create_by(artist)
end

albums_seeds = Rails.root.join("db", "seeds", "albums.yml")
albums = YAML::load_file(albums_seeds)
artist = nil
genre = nil
albums.each do |album|
  artist = Artist.find_by(name: album["artist"]) unless artist&.name == album["artist"]
  raise "Could not find artist #{album["artist"]}" unless artist.present?
  genre = Genre.find_or_create_by(name: album["genre"]) unless genre&.name == album["genre"]
  release_date = ReleaseDate.find_or_create_by(year: album["year"])
  artist.albums.find_or_create_by(title: album["title"], 
                                  genre_id: genre.id, 
                                  release_date_id: release_date.id)
end

tracks_seeds = Rails.root.join("db", "seeds", "tracks.yml")
tracks = YAML::load_file(tracks_seeds)
artist = nil
album = nil
tracks.each do |track|
  artist = Artist.find_by(name: track["artist"]) unless artist&.name == track["artist"]
  raise "Could not find artist #{track["artist"]}" unless artist.present?
  album = Album.find_by(artist_id: artist.id, title: track["album"]) unless album&.title == track["album"]
  raise "Could not find album: #{track["album"]} with id: #{artist.id}" unless album.present?
  album.tracks.find_or_create_by(title: track["title"],
                                 number: track["number"].to_i,
                                 duration: to_seconds(track["duration"]))
end
