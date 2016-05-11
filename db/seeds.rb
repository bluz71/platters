# Raw Artist list:
#  % for i in $(find . -name '01*.mp3'); do mediainfo $i | grep "^Performer"; done | sort | uniq
#
# Raw Album list:
#  % for i in $(find . -name '01*.mp3' | sort); do mediainfo $i | grep "^Performer\|^Album \|^Recorded\|^Genre";echo; done > albums.yml

artists_seeds = Rails.root.join("db", "seeds", "artists.yml")
artists = YAML::load_file(artists_seeds)
artists.each do |artist|
  Artist.find_or_create_by(artist)
end

albums_seeds = Rails.root.join("db", "seeds", "albums.yml")
albums = YAML::load_file(albums_seeds)
artist = nil
albums.each do |album|
  artist = Artist.find_by(name: album["artist"]) unless artist&.name == album["artist"]
  genre = Genre.find_or_create_by(name: album["genre"])
  artist.albums.find_or_create_by(title: album["title"], genre_id: genre.id)
end
