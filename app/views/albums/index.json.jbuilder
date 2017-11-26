json.albums do
  json.array! @albums do |album|
    json.cache! album do
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
end
json.pagination do
  json.current_page @albums.current_page
  json.next_page @albums.next_page
  json.prev_page @albums.prev_page
  json.total_pages @albums.total_pages
  json.total_count @albums.total_count
end
