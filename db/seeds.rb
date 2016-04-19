# Raw Artist list.
#  % for i in $(find . -name '01*.mp3'); do mediainfo $i | grep "^Performer"; done | sort | uniq

seeds_file = Rails.root.join("db", "seeds", "seeds.yml")
config = YAML::load_file(seeds_file)
config["artists"].each do |values|
  Artist.find_or_create_by(values)
end
