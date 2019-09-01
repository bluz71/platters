json.album_of_the_day do
  json.cache! "album_of_the_day_api", expires_in: Time.now.getlocal.end_of_day - Time.now.getlocal do
    album = Album.spotlight
    json.extract! album, :title
    json.artist album.artist.name
    json.artist_slug album.artist.slug
    json.album_slug album.slug
    json.cover_url album.cover.url
  end
end
json.most_recent do
  json.albums do
    json.array! Album.with_relations.most_recent.each do |album|
      json.extract! album, :id, :title, :tracks_count, :comments_count
      json.artist album.artist.name
      json.year album.release_date.year
      json.genre album.genre.name
      json.artist_slug album.artist.slug
      json.album_slug album.slug
      json.cover_url album.cover.small.url
      json.tracks album.tracks_summary
    end
  end
  json.partial! "shared/comments", comments: Comment.most_recent, with_posted_in: true
end
