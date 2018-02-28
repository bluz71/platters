json.albums do
  json.array! @albums do |album|
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
json.pagination do
  json.extract! @albums, :current_page, :next_page, :prev_page, :total_pages, :total_count
end
