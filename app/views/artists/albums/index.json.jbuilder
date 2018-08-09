json.albums do
  json.array! @albums do |album|
    json.extract! album, :id, :title, :tracks_count, :comments_count, :total_duration, :slug
    json.cover_url album.cover.small.url
    json.year album.release_date.year
    json.genre album.genre.name
    json.tracks_summary album.tracks_summary
  end
end
