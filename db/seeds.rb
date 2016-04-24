# Raw Artist list:
#  % for i in $(find . -name '01*.mp3'); do mediainfo $i | grep "^Performer"; done | sort | uniq

artists_seeds = Rails.root.join("db", "seeds", "artists.yml")
artists = YAML::load_file(artists_seeds)
artists.each do |artist|
  Artist.find_or_create_by(artist)
end
