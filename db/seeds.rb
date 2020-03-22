# frozen_string_literal: true

# Raw Artist list from a directory tree of tagged mp3s:
#  % for i in $(find . -name '01_*.mp3' -o -name '001_*.mp3'); do mediainfo $i | \
#      grep "^Performer"; done | sort | uniq
#
# Raw Album list from a directory tree of tagged mp3s:
#  % for i in $(find . -name '01_*.mp3' -o -name '001_*.mp3' | sort); do mediainfo $i | \
#      grep "^Performer\|^Album \|^Recorded\|^Genre";echo; done
#
# Raw Track list from a directory tree of tagged mp3s:
#  % for i in $(find . -name '*.mp3' | sort); do mediainfo $i | \
#      grep "^Performer\|^Album \|^Track\ name\|^Duration" | sort | uniq; echo; done
#
# Covers collecting via the following Ruby script:
#
#   require "fileutils"
#
#   class String
#     def filename_sanitize
#       self.gsub(" ", "_").gsub(/[^0-9A-Za-z_]/, "")
#     end
#   end
#
#   FileUtils.rm_rf("/tmp/covers")
#   FileUtils.mkdir("/tmp/covers")
#   covers_list = `find . -name 'folder.jpg' | sort`.split
#
#   covers_list.each do |cover|
#     first_track = cover.split("/")[0...-1].join("/") << "/01_*.mp3"
#     metadata = `mediainfo #{first_track} | grep "^Album \\|^Performer"`.split("\n")
#     artist = metadata[1].split(": ")[1..-1].join(": ")
#     album = metadata[0].split(": ")[1..-1].join(": ")
#     cover_named = "/tmp/covers/#{artist.filename_sanitize}--"\
#                   "#{album.filename_sanitize}.jpg"
#     FileUtils.cp    cover, cover_named
#     FileUtils.rm_rf Dir.glob("/tmp/covers/*_Bonus.jpg")
#   end

class String
  def to_seconds
    vals = split
    unless vals.size == 4
      raise "Unexpected number of duration values: #{vals.size} for #{self}"
    end

    secs = 0
    if vals[1] == "min"
      secs = (vals[0].to_i * 60) + vals[2].to_i
    elsif vals[1] == "s"
      secs = vals[0].to_i
    end
    secs
  end

  def filename_sanitize
    tr(" ", "_").gsub(/[^0-9A-Za-z_]/, "")
  end

  def made_safe
    tr(".", "_") + rand(100).to_s
  end
end

# The administrator user.
User.create(email: ENV["SEEDED_ADMIN_EMAIL"],
            password: ENV["SEEDED_ADMIN_PASSWORD"],
            name: "admin",
            admin: true,
            email_confirmed_at: Time.current)
# The developer user.
dev_user = User.create(email: ENV["CONTACT_EMAIL"],
                       password: ENV["SEEDED_USER_PASSWORD"],
                       name: "bluz71",
                       email_confirmed_at: Time.current)
# A collection of 50 generated users.
50.times do
  User.create(email: Faker::Internet.email,
              password: ENV["SEEDED_USER_PASSWORD"],
              name: Faker::Internet.user_name.made_safe,
              email_confirmed_at: Time.current)
end
user_count = User.count

artists_seeds = Rails.root.join("db", "seeds", "artists.yml")
artists = YAML.load_file(artists_seeds)
artists.each do |artist_data|
  dev_comment = artist_data.key?("comment") ? artist_data["comment"] : nil
  artist_data.delete("comment")
  begin
    Artist.find_or_create_by!(artist_data)
  rescue ActiveRecord::RecordInvalid
    puts "Validation for #{artist["name"]} failed"
  end
  artist = Artist.last
  rand(50).times do
    comment = artist.comments.create(user: User.find(rand(3..user_count)),
                                     body: Faker::Hipster.paragraph[0..280])
    comment.update_attribute(:created_at, (rand + rand(300)).days.ago)
  end
  if artist.name == "The Beatles"
    # Pad out "The Beatles" with extra comments, it will be used to showcase
    # infinite comment scrolling behavior.
    77.times do
      artist.comments.create(user: User.find(rand(3..user_count)),
                             body: Faker::Hipster.paragraph[0..280])
    end
  end
  dev_user.comments.create(commentable: artist, body: dev_comment) if dev_comment
end

albums_seeds = Rails.root.join("db", "seeds", "albums.yml")
albums = YAML.load_file(albums_seeds)
artist = nil
genre = nil
local_covers_dir = Pathname.new(ENV["HOME"]).join("Pictures", "projects",
                                                  "platters", "covers")
local_covers = FileTest.directory?(local_covers_dir)
albums.each do |album_data|
  unless artist&.name == album_data["artist"]
    artist = Artist.find_by(name: album_data["artist"])
  end
  raise "Could not find artist #{album_data["artist"]}" unless artist.present?

  unless genre&.name == album_data["genre"]
    genre = Genre.find_or_create_by!(name: album_data["genre"])
  end
  release_date = ReleaseDate.find_or_create_by!(year: album_data["year"])
  cover_name = "#{album_data["artist"].filename_sanitize}--"\
               "#{album_data["title"].filename_sanitize}.jpg"
  if local_covers
    cover_location = local_covers_dir.join(cover_name)
    raise "Could not find cover file #{cover_name}" unless FileTest.exist?(cover_location)

    artist.albums.create!(title: album_data["title"],
                          genre_id: genre.id,
                          release_date_id: release_date.id,
                          cover: File.open(cover_location))
  else
    cover_location = ENV["REMOTE_COVERS_HOST"] + cover_name
    artist.albums.create!(title: album_data["title"],
                          genre_id: genre.id,
                          release_date_id: release_date.id,
                          remote_cover_url: cover_location)
  end
  album = Album.last
  rand(50).times do
    comment = album.comments.create(user: User.find(rand(3..user_count)),
                                    body: Faker::Hipster.paragraph[0..280])
    comment.update_attribute(:created_at, (rand + rand(300)).days.ago)
  end
  dev_comment = album_data.key?("comment") ? album_data["comment"] : nil
  dev_user.comments.create(commentable: album, body: dev_comment) if dev_comment
end

tracks_seeds = Rails.root.join("db", "seeds", "tracks.yml")
tracks = YAML.load_file(tracks_seeds)
artist = nil
album = nil
tracks.each do |track|
  artist = Artist.find_by(name: track["artist"]) unless artist&.name == track["artist"]
  raise "Could not find artist #{track["artist"]}" unless artist.present?

  unless album&.title == track["album"]
    album = Album.find_by(artist_id: artist.id, title: track["album"])
  end
  unless album.present?
    raise "Could not find album: #{track["album"]} with id: #{artist.id}"
  end

  album.tracks.create!(title: track["title"],
                       number: track["number"].to_i,
                       duration: track["duration"].to_seconds)
end

# Setup 'New comments'.
20.times do
  album = Album.order("RANDOM()").limit(1).first
  album.comments.create(user: User.find(rand(3..user_count)),
                        body: Faker::Hipster.paragraph[0..280])
end

# Setup the six new albums. Take six random albums from this year and another
# six random albums from last year and touch their updated_at value.
[Date.current.year - 1, Date.current.year].each do |year|
  Album.joins(:release_date)
    .where("release_dates.year IN (?)", year)
    .order("RANDOM()")
    .limit(6)
    .each(&:touch)
end
